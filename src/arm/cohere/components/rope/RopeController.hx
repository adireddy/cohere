package arm.cohere.components.rope;

import arm.cohere.model.Model;
import arm.cohere.core.components.ComponentController;
import bindx.Bind;

class RopeController extends ComponentController {

	@inject public var view:RopeView;

	override public function setup() {
		Bind.bind(model.currentDemo, _onCurrentDemoChange);
	}

	function _onCurrentDemoChange(from:String, to:String) {
		if (to == Model.ROPE) view.start();
		else view.end();
	}
}