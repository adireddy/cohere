package arm.cohere.components.rope;

import js.Browser;
import pixi.mesh.Rope;
import pixi.core.display.Container;
import pixi.core.math.Point;
import pixi.plugins.app.Application;
import pixi.core.textures.Texture;
import arm.cohere.core.components.ComponentView;

class RopeView extends ComponentView {

	var _count:Float;
	var _points:Array<Point>;
	var _length:Float;

	override public function addAssetsToLoad() {
		loader.addAsset(AssetsList.ROPE_SNAKE, AssetsList.ROPE_SNAKE_PNG);
	}

	public function start() {
		_count = 0;
		_points = [];
		_length = Browser.window.innerWidth / 20;

		for (i in 0 ... 20) {
			var segSize = _length;
			_points.push(new Point(i * _length, 0));
		};

		var strip = new Rope(loader.getTexture(AssetsList.ROPE_SNAKE), _points);
		_container.addChild(strip);

		strip.position.set(10, Browser.window.innerHeight / 2);

		if (Main.update != null) Main.update.add(_update);
	}

	function _update(elapsedTime:Float) {
		_count += 0.1;
		for (i in 0 ... _points.length) {
			_points[i].y = Math.sin(i * 0.5 + _count) * 30;
			_points[i].x = i * _length + Math.cos(i * 0.3 + _count) * 20;
		}
	}

	public function end() {
		_container.removeChildren();
		if (Main.update != null) Main.update.remove(_update);
	}
}