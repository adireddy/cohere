package arm.cohere.core.buttons;

import arm.cohere.core.loader.AudioAsset;
import pixi.core.math.Point;
import pixi.core.text.Text;
import pixi.core.textures.Texture;
import pixi.interaction.EventTarget;

class TextButton extends Button {

	var _txt:Text;
	var _upStyle:TextStyle;
	var _overStyle:TextStyle;
	var _downStyle:TextStyle;
	var _disabledStyle:TextStyle;

	public var text(default, set):String;
	public var textStyle(default, set):TextStyle;
	public var textAnchor(default, set):Point;
	public var textPosition(default, set):Point;

	public function new(textures:Array<Texture>, ?textStyles:Array<TextStyle>, ?clickSound:AudioAsset) {
		super(textures, clickSound);

		if (textStyles != null && textStyles.length > 0) {
			if (textStyles[0] != null) _upStyle = textStyles[0];
			if (textStyles[1] != null) _overStyle = textStyles[1];
			if (textStyles[2] != null) _downStyle = textStyles[2];
			if (textStyles[3] != null) _disabledStyle = textStyles[3];
		}

		_txt = new Text("");
		_txt.anchor.set(0.5);
		_txt.position.set(width / 2, height / 2);
		if (_upStyle != null) _txt.style = _upStyle;
		addChild(_txt);
	}

	function set_text(val:String):String {
		_txt.text = val;
		return text = val;
	}

	function set_textStyle(val:TextStyle):TextStyle {
		_txt.style = val;
		return textStyle = val;
	}

	function set_textAnchor(val:Point):Point {
		_txt.anchor = val;
		return textAnchor = val;
	}

	function set_textPosition(val:Point):Point {
		_txt.position = val;
		return textPosition = val;
	}

	override function set_anchor(val:Point):Point {
		_ui.anchor = val;
		_txt.position.set(x, y);
		return anchor = val;
	}

	override function _onMouseDown(?evt:EventTarget) {
		super._onMouseDown(evt);
		if (_downStyle != null) _txt.style = _downStyle;
	}

	override function _onMouseOut(?evt:EventTarget) {
		super._onMouseOut(evt);
		if (_upStyle != null) _txt.style = _upStyle;
	}

	override function _onMouseOver(?evt:EventTarget) {
		super._onMouseOver(evt);
		if (_overStyle != null) _txt.style = _overStyle;
	}

	override public function disable() {
		super.disable();
		if (_disabledStyle != null) _txt.style = _disabledStyle;
	}

	override public function enable() {
		super.enable();
		if (_upStyle != null) _txt.style = _upStyle;
	}

	override public function setTextures(textures:Array<Texture>) {
		super.setTextures(textures);
		_txt.position.set(width / 2, height / 2);
	}

	override public function addIcon(texture:Texture) {
		super.addIcon(texture);
		setChildIndex(_txt, children.length - 1);
	}
}