package arm.cohere.components.tween;

import arm.cohere.model.Model;
import arm.cohere.core.components.ComponentController;
import bindx.Bind;

class TweenController extends ComponentController {

	@inject public var view:TweenView;

	override public function setup() {
		Bind.bind(model.currentDemo, _onCurrentDemoChange);
	}

	function _onCurrentDemoChange(from:String, to:String) {
		if (to == Model.TWEEN) view.start();
		else view.end();
	}
}