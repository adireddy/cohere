package arm.cohere.components.tween;

import pixi.core.sprites.Sprite;
import motion.Actuate;
import arm.cohere.core.components.ComponentView;

class TweenView extends ComponentView {

	var _twnObj:Sprite;

	var _x:Float;

	public var x(get, set):Float;

	function get_x():Float {
		return _x;
	}

	function set_x(value:Float):Float {
		_x = value;
		return _x;
	}

	override public function addAssetsToLoad() {
		loader.addAsset(AssetsList.PRELOADER_LOGO, AssetsList.PRELOADER_LOGO_PNG);
	}

	public function start() {
		_twnObj = new Sprite(loader.getTexture(AssetsList.PRELOADER_LOGO));
		_twnObj.anchor.set(0.5);
		_twnObj.alpha = 0;
		_container.addChild(_twnObj);

		Actuate.tween(_twnObj, 2, { alpha: 1 }).repeat().reflect().delay(1);

		_resize();
		if (Main.resize != null) Main.resize.add(_resize);
	}

	public function end() {
		_container.removeChildren();
		if (Main.resize != null) Main.resize.remove(_resize);
	}

	function _resize() {
		_container.position.set(stageProperties.screenWidth / 2, stageProperties.screenHeight / 2 - 25);
	}
}