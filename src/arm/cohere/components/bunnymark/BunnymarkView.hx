package arm.cohere.components.bunnymark;

import pixi.core.math.shapes.Rectangle;
import pixi.core.text.Text;
import js.html.Event;
import js.Browser;
import pixi.core.particles.ParticleContainer;
import pixi.core.textures.Texture;
import arm.cohere.core.components.ComponentView;

class BunnymarkView extends ComponentView {

	public var useWorker:Bool;

	var _bunnyTexture:Texture;
	var _bunnys:Array<Bunny> = [];
	var _bunnyTextures:Array<Texture> = [];

	var _gravity:Float = 0.5;

	var _maxX:Float;
	var _maxY:Float;

	var _count:Int = 0;
	var _bunnyContainer:ParticleContainer;

	var _bunnyType:Int;
	var _currentTexture:Texture;
	var _counter:Text;

	override public function addAssetsToLoad() {
		loader.addAsset(AssetsList.BUNNYMARK_BUNNYS, AssetsList.BUNNYMARK_BUNNYS_PNG);
	}

	public function start() {
		_maxX = Browser.window.innerWidth;
		_maxY = Browser.window.innerHeight;

		_counter = new Text("0 BUNNIES (touch/click to add)", { fill: "#105CB6", font: "bold 12px Courier" });
		_container.addChild(_counter);

		_bunnyContainer = new ParticleContainer();
		_bunnyContainer.addChild(_bunnyContainer);
		_container.addChild(_bunnyContainer);

		_bunnyTexture = loader.getTexture(AssetsList.BUNNYMARK_BUNNYS);
		var bunny1 = new Texture(_bunnyTexture.baseTexture, new Rectangle(2, 47, 26, 37));
		var bunny2 = new Texture(_bunnyTexture.baseTexture, new Rectangle(2, 86, 26, 37));
		var bunny3 = new Texture(_bunnyTexture.baseTexture, new Rectangle(2, 125, 26, 37));
		var bunny4 = new Texture(_bunnyTexture.baseTexture, new Rectangle(2, 164, 26, 37));
		var bunny5 = new Texture(_bunnyTexture.baseTexture, new Rectangle(2, 2, 26, 37));

		_bunnyTextures = [bunny1, bunny2, bunny3, bunny4, bunny5];
		_bunnyType = 1;
		_currentTexture = _bunnyTextures[_bunnyType];

		Browser.document.addEventListener("touchstart", _onTouchStart, true);
		Browser.document.addEventListener("mousedown", _onTouchStart, true);
		if (Main.update != null) Main.update.add(_update);
		if (Main.resize != null) Main.resize.add(_resize);
	}

	function _onTouchStart(event:Event) {
		_bunnyType++;
		_bunnyType %= 5;
		_currentTexture = _bunnyTextures[_bunnyType];

		if (_count < 200000) {
			for (i in 0 ... 500) {
				var bunny = new Bunny(_currentTexture);
				bunny.speedX = Math.random() * 5;
				bunny.speedY = (Math.random() * 5) - 3;
				bunny.anchor.set(0, 1);
				bunny.scale.set(0.5 + Math.random() * 0.5, 0.5 + Math.random() * 0.5);
				bunny.rotation = (Math.random() - 0.5);
				_bunnys.push(bunny);
				_container.addChild(bunny);
				_count++;
			}
		}
		_counter.text = _count + " BUNNIES";
	}

	function _update(elapsedTime:Float) {
		for (i in 0 ... _bunnys.length) {
			var bunny = _bunnys[i];
			bunny.position.x += bunny.speedX;
			bunny.position.y += bunny.speedY;
			bunny.speedY += _gravity;

			if (bunny.position.x > _maxX) {
				bunny.speedX *= -1;
				bunny.position.x = _maxX;
			}
			else if (bunny.position.x < 0) {
				bunny.speedX *= -1;
				bunny.position.x = 0;
			}

			if (bunny.position.y > _maxY) {
				bunny.speedY *= -0.85;
				bunny.position.y = _maxY;
				if (Math.random() > 0.5) bunny.speedY -= Math.random() * 6;
			}
			else if (bunny.position.y < 0) {
				bunny.speedY = 0;
				bunny.position.y = 0;
			}
		}
	}

	function _resize() {
		_maxX = Browser.window.innerWidth;
		_maxY = Browser.window.innerHeight;
	}

	public function end() {
		_container.removeChildren();
		_counter = null;
		_bunnyContainer = null;
		_count = 0;
		_bunnyTextures = [];

		Browser.document.removeEventListener("touchstart", _onTouchStart, true);
		Browser.document.removeEventListener("mousedown", _onTouchStart, true);
	}
}