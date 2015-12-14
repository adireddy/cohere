package arm.cohere.core.loader;

import pixi.loaders.Resource;
import pixi.core.textures.Texture;
import pixi.loaders.Loader;

class AssetLoader extends Loader {

	public var pixelRatio(null, default):Float;
	public var count(default, null):Int;
	public var loadProgress:Float;
	public var resolution(default, default):String;
	public var muteAudio(default, set):Bool;

	var _onComplete:Void -> Void;
	var _onProgress:Void -> Void;
	var _loadCount:Int;
	var _audioCount:Int;
	var _audioKeys:Array<String>;
	var _audioAssets:Map<String, AudioAsset>;
	var _audioAssetPaths:Map<String, String>;

	public function new() {
		super();
		count = 0;
		loadProgress = 0;
		pixelRatio = 1;
		_loadCount = 0;
		_audioCount = 0;
		_audioKeys = [];
		_audioAssets = new Map();
		_audioAssetPaths = new Map();
		MultipackParser.loader = this;
		use(MultipackParser.parse);
	}

	public function start(?onComplete:Void -> Void, ?onProgress:Void -> Void) {
		_onComplete = onComplete;
		_onProgress = onProgress;

		if (_audioCount > 0) _loadAudioAsset();
		else load(_onComplete);
	}

	function _loadAudioAsset() {
		var id = _audioKeys.pop();
		_audioAssets.set(id, new AudioAsset(baseUrl + _audioAssetPaths.get(id), false, false, _onAudioAssetLoaded, _onAudioAssetLoadError));
	}

	function _onAudioAssetLoaded(snd:ISound) {
		_checkAudioLoadCount();
	}

	function _onAudioAssetLoadError(snd:ISound) {
		_checkAudioLoadCount();
	}

	inline function _checkAudioLoadCount() {
		_loadCount++;
		if (_loadCount == _audioCount) {
			if (count - _audioCount > 0) load(_onComplete);
			else _onComplete();
		}
		else if (_audioKeys.length > 0) _loadAudioAsset();
		_checkProgress();
	}

	function _onAssetLoaded(resource:Resource) {
		_loadCount++;
		_checkProgress();
	}

	function _checkProgress() {
		loadProgress = (_loadCount / count) * 100;
		if (_onProgress != null) _onProgress();
	}

	public inline function addAudioAsset(id:String, path:String) {
		count++;
		_audioCount++;
		_audioAssetPaths.set(id, path);
		_audioKeys.push(id);
	}

	public function addAsset(id:String, path:String, ?usePixelRatio:Bool = true) {
		if (!exists(id)) {
			var url:String = "";
			if (usePixelRatio) {
				if (AssetsList.exists(baseUrl + getResoultionPath() + getPixelRatioPath() + path)) {
					url = getResoultionPath() + getPixelRatioPath() + path;
				}
				else if (AssetsList.exists(baseUrl + getResoultionPath() + getPixelRatioPath(1) + path)) {
					url = getResoultionPath() + getPixelRatioPath(1) + path;
				}
			}
			else if (AssetsList.exists(baseUrl + getResoultionPath() + path)) url = getResoultionPath() + path;
			else if (AssetsList.exists(baseUrl + path)) url = path;

			if (url != "") {
				add(id, url, { loadType: _getLoadtype(path) }, _onAssetLoaded);
				count++;
			}
			else JConsole.info("'" + baseUrl + path + "' not availabble in AssetList. Make sure the asset is available or run the build to update AssetsList");
		}
	}

	public inline function getUrl(id:String):String {
		return Reflect.field(resources, id) != null ? Reflect.field(resources, id).url : null;
	}

	@SuppressWarnings("checkstyle:Dynamic")
	public function getJson(id:String):Dynamic {
		var resource:Resource = Reflect.field(resources, id);
		if (resource != null && ~/(json|text|txt)/i.match(resource.xhrType)) return resource.data;
		else JConsole.error("JSON wth index '" + id + "' not found");
		return null;
	}

	public function getTexture(id:String):Texture {
		var resource:Resource = Reflect.field(resources, id);
		if (resource != null && resource.texture != null) return resource.texture;
		else if (Texture.fromFrame(id) != null) return Texture.fromFrame(id);
		else JConsole.error("Texture with id '" + id + "' not found");
		return null;
	}

	public function getTextureFromSpritesheet(id:String, frame:String):Texture {
		var resource:Resource = Reflect.field(resources, id);
		if (resource != null && resource.isJson && resource.textures != null) {
			var texture = Reflect.field(resource.textures, frame);
			if (texture != null) return texture;
			else JConsole.error("Texture with frame'" + frame + "' not found in " + id);
		}
		else JConsole.error("Spritesheet with id '" + id + "' not found");
		return null;
	}

	public inline function exists(id:String):Bool {
		return (Reflect.field(resources, id) != null);
	}

	public function playAudio(id:String, ?loop:Bool = false, ?onend:Void -> Void) {
		var snd:AudioAsset = _audioAssets.get(id);
		snd.play(loop, onend);
	}

	public function playAudioOnDemand(id:String, url:String, ?loop:Bool = false, ?onend:Void -> Void) {
		JConsole.log("ID: " + id);
		var snd:AudioAsset;
		if (_audioAssets.get(id) == null) {
			snd = new AudioAsset(baseUrl + url, true, loop);
			_audioAssets.set(id, snd);
		}
		else {
			snd = _audioAssets.get(id);
			snd.play(loop, onend);
		}
	}

	public function getAudio(id:String):AudioAsset {
		if (_audioAssets.get(id) != null) return _audioAssets.get(id);
		else JConsole.error("Audio with id '" + id + "' not found");
		return null;
	}

	override public function reset() {
		removeAllListeners();
		count = 0;
		_loadCount = 0;
		_audioCount = 0;
		loadProgress = 0;
		_audioKeys = [];
		resources = {};
		super.reset();
	}

	public inline function getResoultionPath():String {
		return (resolution != null) ? resolution + "/" : "";
	}

	public inline function getPixelRatioPath(?val:Float):String {
		return (val != null) ? "@" + val + "x/" : "@" + pixelRatio + "x/";
	}

	function set_muteAudio(val:Bool):Bool {
		Waud.mute(val);
		return muteAudio = val;
	}

	function _getLoadtype(asset:String):Int {
		//type: XHR: 1, IMAGE: 2, AUDIO: 3, VIDEO: 4
		if (~/(.png|.gif|.svg|.jpg|.jpeg|.bmp)/i.match(asset)) return 2;
		else if (~/(.mp3|.wav|.ogg|.aac|.m4a|.oga|.webma)/i.match(asset)) return 3;
		else if (~/(.mp4|.webm|.m3u8)/i.match(asset)) return 4;
		return 1;
	}
}