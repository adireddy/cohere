package arm.cohere.components.graphics;

import pixi.core.math.shapes.Rectangle;
import js.Browser;
import pixi.core.graphics.Graphics;
import pixi.core.textures.Texture;
import arm.cohere.core.components.ComponentView;

class GraphicsView extends ComponentView {

	var _graphics:Graphics;
	var _thing:Graphics;
	var _count:Float;

	public function start() {
		_count = 0;
		_graphics = new Graphics();
		_graphics.beginFill(0xFF3300);
		_graphics.lineStyle(10, 0xffd900, 1);

		_graphics.moveTo(50, 50);
		_graphics.lineTo(250, 50);
		_graphics.lineTo(100, 100);
		_graphics.lineTo(250, 220);
		_graphics.lineTo(50, 220);
		_graphics.lineTo(50, 50);
		_graphics.endFill();

		_graphics.lineStyle(10, 0xFF0000, 0.8);
		_graphics.beginFill(0xFF700B, 1);

		_graphics.moveTo(210, 300);
		_graphics.lineTo(450, 320);
		_graphics.lineTo(570, 350);
		_graphics.lineTo(580, 20);
		_graphics.lineTo(330, 120);
		_graphics.lineTo(410, 200);
		_graphics.lineTo(210, 300);
		_graphics.endFill();

		_graphics.lineStyle(2, 0x0000FF, 1);
		_graphics.drawRect(50, 250, 100, 100);

		_graphics.lineStyle(0);
		_graphics.beginFill(0xFFFF0B, 0.5);
		_graphics.drawCircle(470, 200, 100);

		_graphics.lineStyle(20, 0x33FF00);
		_graphics.moveTo(30, 30);
		_graphics.lineTo(600, 300);

		_container.addChild(_graphics);

		_thing = new Graphics();
		_container.addChild(_thing);

		_container.interactive = true;
		_container.hitArea = new Rectangle(0, 0, Browser.window.innerWidth, Browser.window.innerHeight);
		_container.on("click", _onStageClick);
		_container.on("tap", _onStageClick);

		_resize();

		if (Main.update != null) Main.update.add(_update);
		if (Main.resize != null) Main.resize.add(_resize);
	}

	function _update(t:Float) {
		_count += 0.1;
		_thing.clear();
		_thing.lineStyle(30, 0xFF0000, 1);
		_thing.beginFill(0xFF0000, 0.5);

		_thing.moveTo(-120 + Math.sin(_count) * 20, -100 + Math.cos(_count) * 20);
		_thing.lineTo(120 + Math.cos(_count) * 20, -100 + Math.sin(_count) * 20);
		_thing.lineTo(120 + Math.sin(_count) * 20, 100 + Math.cos(_count) * 20);
		_thing.lineTo(-120 + Math.cos(_count) * 20, 100 + Math.sin(_count) * 20);
		_thing.lineTo(-120 + Math.sin(_count) * 20, -100 + Math.cos(_count) * 20);

		_thing.rotation = _count * 0.1;
	}

	function _onStageClick() {
		_graphics.lineStyle(Math.random() * 30, Std.int(Math.random() * 0xFFFFFF), 1);
		_graphics.moveTo(Math.random() * Browser.window.innerWidth, Math.random() * Browser.window.innerHeight);
		_graphics.lineTo(Math.random() * Browser.window.innerWidth, Math.random() * Browser.window.innerHeight);
	}

	public function end() {
		_container.removeChildren();
		_container.interactive = false;
		_container.off("click", _onStageClick);
		_container.off("tap", _onStageClick);
		_graphics = null;
		_thing = null;
		if (Main.update != null) Main.update.remove(_update);
		if (Main.resize != null) Main.resize.remove(_resize);
	}

	function _resize() {
		_graphics.position.set(Browser.window.innerWidth / 2 - _graphics.width / 2, Browser.window.innerHeight / 2 - _graphics.height / 2);
		_thing.position.set(Browser.window.innerWidth / 2, Browser.window.innerHeight / 2);
	}
}