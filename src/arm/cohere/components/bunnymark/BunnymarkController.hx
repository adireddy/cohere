package arm.cohere.components.bunnymark;

import arm.cohere.model.Model;
import arm.cohere.core.components.ComponentController;
import bindx.Bind;

class BunnymarkController extends ComponentController {

	@inject public var view:BunnymarkView;

	override public function setup() {
		Bind.bind(model.currentDemo, _onCurrentDemoChange);
	}

	function _onCurrentDemoChange(from:String, to:String) {
		if (to == Model.BUNNYMARK) view.start();
		else view.end();
	}
}