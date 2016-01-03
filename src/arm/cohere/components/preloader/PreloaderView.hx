package arm.cohere.components.preloader;

import pixi.core.graphics.Graphics;
import msignal.Signal.Signal0;
import pixi.core.sprites.Sprite;
import pixi.core.display.Container;
import arm.cohere.core.components.ComponentView;

class PreloaderView extends ComponentView {

	public var ready:Signal0;

	var _logo:Sprite;
	var _loadingBarContainer:Container;
	var _loadingBar:Graphics;
	var _loadingBarBG:Graphics;

	override public function init() {
		super.init();
		ready = new Signal0();
	}

	public function setup() {
		loader.addAsset(AssetsList.PRELOADER_LOGO, AssetsList.PRELOADER_LOGO_PNG);
		loader.start(_onLoaded);
	}

	function _onLoaded() {
		_logo = new Sprite(loader.getTexture(AssetsList.PRELOADER_LOGO));
		_logo.anchor.set(0.5);
		_container.addChild(_logo);

		_createLoadingBar();
		_resize();
		if (Main.update != null) Main.update.add(_update);
		if (Main.resize != null) Main.resize.add(_resize);

		loader.reset();
		ready.dispatch();
	}

	function _createLoadingBar() {
		_loadingBarContainer = new Container();
		_container.addChild(_loadingBarContainer);

		_loadingBarBG = new Graphics();
		_loadingBarBG.beginFill(0xD8D8D8);
		_loadingBarBG.drawRect(0, 0, 204, 26);
		_loadingBarBG.endFill();

		_loadingBar = new Graphics();
		_loadingBar.beginFill(0xFF0055);
		_loadingBar.drawRect(0, 0, 200, 22);
		_loadingBar.endFill();

		_loadingBarContainer.addChild(_loadingBarBG);
		_loadingBarContainer.addChild(_loadingBar);
		_loadingBar.x = _loadingBar.y = 2;
		_loadingBar.scale.x = 0.02;

		_loadingBarContainer.position.set(_logo.x - _loadingBarBG.width / 2, _logo.y + _logo.height / 2 + 10);
	}

	public function reset() {
		_container.removeChild(_logo);
		_container.removeChild(_loadingBarContainer);
		_loadingBarContainer = null;
		_logo = null;
	}

	function _update(elapsed:Float) {
		if (_loadingBar != null) _loadingBar.scale.x = loader.loadProgress / 100;
	}

	function _resize() {
		_container.position.set(stageProperties.screenWidth / 2, stageProperties.screenHeight / 2 - 25);
	}
}