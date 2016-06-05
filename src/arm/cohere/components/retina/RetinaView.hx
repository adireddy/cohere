package arm.cohere.components.retina;

import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import js.Browser;
import arm.cohere.core.components.ComponentView;

class RetinaView extends ComponentView {

	var _img:Sprite;
	var _label:Text;

	override public function addAssetsToLoad() {
		loader.addAsset(AssetsList.RETINA_IMG, AssetsList.RETINA_IMG_JPG);
	}

	function _getPixelRatio():Float {
		return (Browser.window.devicePixelRatio >= 2) ? 2 : 1;
	}

	public function start() {
		_img = new Sprite(loader.getTexture(AssetsList.RETINA_IMG));
		_img.anchor.set(0.5);
		_img.name = "img";
		_img.position.set(Browser.window.innerWidth / 2, Browser.window.innerHeight / 2);
		_container.addChild(_img);

		_label = new Text("Pixel Ratio: " + _getPixelRatio(), { fill: "#105CB6", font: "bold 12px Courier" });
		_container.addChild(_label);
	}

	public function end() {
		_container.removeChildren();
		_img = null;
		_label = null;
	}
}