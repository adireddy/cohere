package arm.cohere.model;

import msignal.Signal.Signal0;
import msignal.Signal.Signal1;
import bindx.Bind;
import bindx.IBindable;

using bindx.Bind;

class Model implements IBindable {

	public static inline var BUNNYMARK:String = "bunnymark";
	public static inline var RETINA:String = "retina";
	public static inline var SPRITESHEET:String = "spritesheet";
	public static inline var BITMAPFONT:String = "bitmapfont";
	public static inline var GRAPHICS:String = "graphics";
	public static inline var ROPE:String = "rope";
	public static inline var TWEEN:String = "tween";
	public static inline var PHYSICS:String = "physics";

	public var addAssets:Signal0;
	public var updateFps:Signal1<Int>;

	public var preloaderReady(default, set):Bool;
	public var fps(default, set):Int;

	@:bindable public var currentDemo:String;

	public function new() {
		addAssets = new Signal0();
		updateFps = new Signal1(Int);
	}

	public function init() {}

	public function reset() {}

	function set_preloaderReady(val:Bool):Bool {
		if (val) addAssets.dispatch();
		return preloaderReady = val;
	}

	function set_fps(val:Int):Int {
		updateFps.dispatch(val);
		return fps = val;
	}
}