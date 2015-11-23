package arm.cohere.core.loader;

import howler.Howl;

class AudioAsset {

	public var volume(default, set):Float;

	var _snd:Howl;

	public function new(path:String, ?autoPlay:Bool = false, ?loop:Bool = false, ?loadComplete:Void -> Void, ?loadError:Void -> Void) {
		var options:HowlOptions = {};
		options.src = [path];
		options.autoplay = autoPlay;
		options.loop = loop;
		if (loadComplete != null) options.onload = loadComplete;
		if (loadError != null) options.onloaderror = loadError;
		_snd = new Howl(options);
	}

	public function play(?loop:Bool = false, ?onend:Void -> Void) {
		if (_snd.playing()) _snd.stop();
		_snd.play();
		_snd.loop(loop);
		if (onend != null) _snd.once("end", onend);
	}

	public function stop() {
		_snd.stop();
	}

	public function pause() {
		_snd.pause();
	}

	function set_volume(val:Float):Float {
		_snd.volume(val);
		return volume = val;
	}
}