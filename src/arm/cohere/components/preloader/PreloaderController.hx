package arm.cohere.components.preloader;

import arm.cohere.core.components.ComponentController;

class PreloaderController extends ComponentController {

	@inject public var view:PreloaderView;

	override public function init() {
		super.init();
		view.setup();
		view.ready.addOnce(_onReady);
	}

	override public function setup() {
		view.reset();
		view = null;
	}

	function _onReady() {
		model.preloaderReady = true;
	}
}