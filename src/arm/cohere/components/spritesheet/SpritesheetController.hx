package arm.cohere.components.spritesheet;

import arm.cohere.model.Model;
import arm.cohere.core.components.ComponentController;
import bindx.Bind;

class SpritesheetController extends ComponentController {

	@inject public var view:SpritesheetView;

	override public function setup() {
		Bind.bind(model.currentDemo, _onCurrentDemoChange);
	}

	function _onCurrentDemoChange(from:String, to:String) {
		if (to == Model.SPRITESHEET) view.start();
		else view.end();
	}
}