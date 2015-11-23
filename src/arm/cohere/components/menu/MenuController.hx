package arm.cohere.components.menu;

import arm.cohere.core.components.ComponentController;

class MenuController extends ComponentController {

	@inject public var view:MenuView;

	override public function setup() {
		view.setup();
		view.demo.add(_onDemoChange);
		view.fps.add(_onFpsChange);
	}

	function _onDemoChange(val:String) {
		model.currentDemo = val.toLowerCase();
	}

	function _onFpsChange(val:Int) {
		model.fps = val;
	}
}