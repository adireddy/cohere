package arm.cohere.components.menu;

import dat.controllers.Controller;
import msignal.Signal.Signal1;
import dat.gui.GUI;

import arm.cohere.core.components.ComponentView;

class MenuView extends ComponentView {

	public var demo:Signal1<String>;
	public var fps:Signal1<Int>;

	var _menu:GUI;
	var _demoList:Controller;
	var _fps:Controller;
	var _data:Dynamic;

	public function setup() {
		demo = new Signal1(String);
		fps = new Signal1(Int);

		_data = { demo: "", fps: 60 }

		_menu = new GUI();
		_demoList = _menu.add(_data, "demo", ["none", "Retina", "Bunnymark", "Spritesheet", "Bitmapfont", "Graphics"]);
		_demoList.onChange(_changeDemo);

		_fps = _menu.add(_data, "fps", 1, 60);
		_fps.onChange(_changeFps);
	}

	function _changeDemo(val:String) {
		demo.dispatch(val);
	}

	function _changeFps(val:Int) {
		fps.dispatch(val);
	}
}