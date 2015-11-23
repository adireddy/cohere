package arm.cohere.view;

import arm.cohere.core.loader.AssetLoader;
import pixi.core.display.Container;

class View {

	@inject public var loader:AssetLoader;

	public var stage(default, null):Container;

	public function new(stage:Container) {
		this.stage = stage;
	}

	public function init() {}

	public function reset() {
		stage.removeChildren();
	}

	public function addAssetsToLoad() {
		loader.addAsset(AssetsList.COMMON_BUTTON, AssetsList.COMMON_BUTTON_PNG);
	}
}