package arm.cohere.core.loader;

class AudioAsset {

	public var volume(default, set):Float;

	var _snd:WaudSound;

	public function new(path:String, ?autoPlay:Bool = false, ?loop:Bool = false, ?loadComplete:IWaudSound -> Void, ?loadError:IWaudSound -> Void) {
		var options:WaudSoundOptions = {};
		options.autoplay = autoPlay;
		options.loop = loop;
		if (loadComplete != null) options.onload = loadComplete;
		if (loadError != null) options.onerror = loadError;
		_snd = new WaudSound(path, options);
	}

	public function play(?loop:Bool = false, ?onend:IWaudSound -> Void) {
		_snd.stop();
		_snd.loop(loop);
		_snd.play();
		if (onend != null) _snd.onEnd(onend);
	}

	public function stop() {
		_snd.stop();
	}

	function set_volume(val:Float):Float {
		_snd.setVolume(val);
		return volume = val;
	}
}