package arm.cohere.components.bitmapfont;

import arm.cohere.model.Model;
import arm.cohere.core.components.ComponentController;
import bindx.Bind;

class BitmapfontController extends ComponentController {

	@inject public var view:BitmapfontView;

	override public function setup() {
		Bind.bind(model.currentDemo, _onCurrentDemoChange);
	}

	function _onCurrentDemoChange(from:String, to:String) {
		if (to == Model.BITMAPFONT) view.start();
		else view.end();
	}
}