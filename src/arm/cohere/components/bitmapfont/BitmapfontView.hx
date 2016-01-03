package arm.cohere.components.bitmapfont;

import pixi.extras.BitmapText;
import arm.cohere.core.components.ComponentView;

class BitmapfontView extends ComponentView {

	var _bitmapFont:BitmapText;

	override public function addAssetsToLoad() {
		loader.addAsset(AssetsList.FONTS_DESYREL, AssetsList.FONTS_DESYREL_XML);
	}

	public function start() {
		_bitmapFont = new BitmapText("bitmap fonts are\n now supported!", {font: "60px Desyrel"});
		_container.addChild(_bitmapFont);

		_resize();
		if (Main.resize != null) Main.resize.add(_resize);
	}

	public function end() {
		_container.removeChildren();
		_bitmapFont = null;
	}

	function _resize() {
		_container.position.set((stageProperties.screenWidth - _container.width) / 2, (stageProperties.screenHeight - _container.height) / 2);
	}
}