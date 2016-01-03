package arm.cohere.components.graphics;

import arm.cohere.model.Model;
import arm.cohere.core.components.ComponentController;
import bindx.Bind;

class GraphicsController extends ComponentController {

	@inject public var view:GraphicsView;

	override public function setup() {
		Bind.bind(model.currentDemo, _onCurrentDemoChange);
	}

	function _onCurrentDemoChange(from:String, to:String) {
		if (to == Model.GRAPHICS) view.start();
		else view.end();
	}
}