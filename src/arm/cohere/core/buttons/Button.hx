package arm.cohere.core.buttons;

import arm.cohere.core.loader.AudioAsset;
import pixi.core.math.Point;
import msignal.Signal.Signal0;
import msignal.Signal.Signal2;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import pixi.core.display.Container;
import pixi.interaction.EventTarget;

class Button extends Container {

	var _ui:Sprite;

	var _upTexture:Texture;
	var _overTexture:Texture;
	var _downTexture:Texture;
	var _disabledTexture:Texture;
	var _clickSound:AudioAsset;

	public var stopBubbling:Bool;

	public var clicked:Signal0;
	public var touchStart:Signal0;

	public var anchor(default, set):Point;

	public function new(textures:Array<Texture>, ?clickSound:AudioAsset) {
		super();
		_clickSound = clickSound;
		if (textures.length == 0) throw("Button textures cannot be empty");
		else {
			if (textures[0] != null) _upTexture = textures[0];
			if (textures[1] != null) _overTexture = textures[1];
			if (textures[2] != null) _downTexture = textures[2];
			if (textures[3] != null) _disabledTexture = textures[3];
		}

		_ui = new Sprite(_upTexture);
		addChild(_ui);

		interactive = true;
		buttonMode = true;

		stopBubbling = true;

		clicked = new Signal0();
		touchStart = new Signal0();

		on("tap", _onTap);
		on("touchmove", _onTouchMove);
		on("touchstart", _onTouchStart);
		on("touchend", _onTouchEnd);

		on("click", _onTap);
		on("mouseover", _onMouseOver);
		on("mouseout", _onMouseOut);
		on("mousedown", _onMouseDown);
	}

	function _onTap(?evt:EventTarget) {
		if (evt != null) evt.stopped = stopBubbling;
		_ui.texture = _upTexture;
		if (_clickSound != null) _clickSound.play();
		clicked.dispatch();
	}

	function _onTouchMove(?evt:EventTarget) {
		// evt.stopped = stopBubbling;		//There is a bug with PixiJS and ALL buttons will get Move events, so can't eat move events
	}

	function _onTouchStart(?evt:EventTarget) {
		touchStart.dispatch();
		if (evt != null) evt.stopped = stopBubbling;
	}

	function _onTouchEnd(?evt:EventTarget) {
		// evt.stopped = stopBubbling;		//Seems to be another bug, eating this stops 'tap' from happening
	}

	function _onMouseDown(?evt:EventTarget) {
		if (evt != null) evt.stopped = stopBubbling;
		if (_downTexture != null) _ui.texture = _downTexture;
	}

	function _onMouseOut(?evt:EventTarget) {
		evt.stopped = stopBubbling;
		if (_ui.texture != _upTexture) _ui.texture = _upTexture;
	}

	function _onMouseOver(?evt:EventTarget) {
		if (evt != null) evt.stopped = stopBubbling;
		if (_overTexture != null) _ui.texture = _overTexture;
	}

	function set_anchor(val:Point):Point {
		_ui.anchor = val;
		return anchor = val;
	}

	public function disable() {
		if (_disabledTexture != null) _ui.texture = _disabledTexture;
		interactive = false;
	}

	public function enable() {
		_ui.texture = _upTexture;
		interactive = true;
	}

	public function setTextures(textures:Array<Texture>) {
		if (textures[0] != null) _upTexture = textures[0];
		if (textures[1] != null) _overTexture = textures[1];
		if (textures[2] != null) _downTexture = textures[2];
		if (textures[3] != null) _disabledTexture = textures[3];
		_ui.texture = _upTexture;
	}

	public function addIcon(texture:Texture) {
		var icon:Sprite = new Sprite(texture);
		icon.anchor.set(0.5);
		icon.position.set(width / 2, height / 2);
		addChild(icon);
	}
}