package arm.cohere.components.retina;

import arm.cohere.model.Model;
import arm.cohere.core.components.ComponentController;
import bindx.Bind;

class RetinaController extends ComponentController {

	@inject public var view:RetinaView;

	override public function setup() {
		Bind.bind(model.currentDemo, _onCurrentDemoChange);
	}

	function _onCurrentDemoChange(from:String, to:String) {
		if (to == Model.RETINA) view.start();
		else view.end();
	}
}