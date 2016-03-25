package arm.cohere.components.physics;

import arm.cohere.model.Model;
import arm.cohere.core.components.ComponentController;
import bindx.Bind;

class PhysicsController extends ComponentController {

	@inject public var view:PhysicsView;

	override public function setup() {
		Bind.bind(model.currentDemo, _onCurrentDemoChange);
	}

	function _onCurrentDemoChange(from:String, to:String) {
		if (to == Model.PHYSICS) view.start();
		else view.end();
	}
}