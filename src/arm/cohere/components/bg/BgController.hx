package arm.cohere.components.bg;

import arm.cohere.model.Model;
import arm.cohere.core.components.ComponentController;

class BgController extends ComponentController {

	@inject public var view:BgView;

	override public function setup() {
		view.playBgSound();
	}

	function _onCurrentDemoChange(from:String, to:String) {

	}
}