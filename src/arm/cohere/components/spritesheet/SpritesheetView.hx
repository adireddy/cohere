package arm.cohere.components.spritesheet;

import pixi.extras.MovieClip;
import js.html.Event;
import pixi.core.textures.Texture;
import pixi.core.sprites.Sprite;
import pixi.core.text.Text;
import js.Browser;
import arm.cohere.core.components.ComponentView;

class SpritesheetView extends ComponentView {

	var _counter:Text;
	var _fighterTextures:Array<Texture>;
	var _count:Int;
	var _isAdding:Bool;

	override public function addAssetsToLoad() {
		loader.addAsset(AssetsList.SPRITESHEET_FIGHTER, AssetsList.SPRITESHEET_FIGHTER_JSON);
	}

	function _getPixelRatio():Float {
		return (Browser.window.devicePixelRatio >= 2) ? 2 : 1;
	}

	public function start() {
		_count = 0;
		_isAdding = false;
		_fighterTextures = [];

		for (i in 0 ... 29) {
			var frame:String = "" + i;
			if (i < 10) frame = "0" + frame;
			_fighterTextures.push(loader.getTexture("rollSequence00" + frame + ".png"));
		}

		_counter = new Text(_count + " SPRITES", { fill: "#105CB6", font: "bold 12px Courier" });
		_container.addChild(_counter);

		_addFighter(Browser.window.innerWidth / 2, Browser.window.innerHeight / 2);

		Browser.document.addEventListener("touchstart", _onTouchStart, true);
		Browser.document.addEventListener("touchend", _onTouchEnd, true);
		Browser.document.addEventListener("mousedown", _onTouchStart, true);
		Browser.document.addEventListener("mouseup", _onTouchEnd, true);
	}

	function _onTouchStart(event:Event) {
		_isAdding = true;
	}

	function _onTouchEnd(event:Event) {
		_isAdding = false;
	}

	function _addFighter(x:Float, y:Float) {
		var fighter:MovieClip = new MovieClip(_fighterTextures);
		fighter.anchor.set(0.5);
		fighter.position.set(x, y);
		fighter.play();

		_container.addChild(fighter);
		_count++;
		_counter.text = _count + " SPRITES";
	}

	override public function update(elapsedTime:Float) {
		if (_isAdding) _addFighter(Std.random(Browser.window.innerWidth), Std.random(Browser.window.innerHeight));
	}

	public function end() {
		_container.removeChildren();
		_count = 0;
		_isAdding = false;
		_fighterTextures = [];

		Browser.document.removeEventListener("touchstart", _onTouchStart, true);
		Browser.document.removeEventListener("touchend", _onTouchEnd, true);
		Browser.document.removeEventListener("mousedown", _onTouchStart, true);
		Browser.document.removeEventListener("mouseup", _onTouchEnd, true);
	}
}