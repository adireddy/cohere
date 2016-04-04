package arm.cohere.components.physics;

import js.Browser;
import pixi.core.sprites.Sprite;
import pixi.core.textures.Texture;
import nape.geom.Vec2;
import nape.shape.Circle;
import nape.phys.Material;
import nape.phys.BodyType;
import nape.shape.Polygon;
import haxe.Timer;
import nape.space.Space;
import nape.phys.Body;
import pixi.core.display.Container;
import arm.cohere.core.components.ComponentView;

class PhysicsView extends ComponentView {

	var _floor:Body;
	var _space:Space;
	var _balls:Array<Sprite>;
	var _pballs:Array<Body>;
	var _timer:Timer;

	override public function addAssetsToLoad() {
		loader.addAsset(AssetsList.NAPE_BALL, AssetsList.NAPE_BALL_PNG);
	}

	public function start() {
		_balls = [];
		_pballs = [];
		_setUpPhysics();
		_timer = new Timer(1000);
		_timer.run = _addBall;
		_addBall();

		if (Main.update != null) Main.update.add(_update);
	}

	function _setUpPhysics() {
		var gravity = Vec2.weak(0, 600);
		_space = new Space(gravity);

		_floor = new Body(BodyType.STATIC);
		_floor.setShapeMaterials(Material.wood());
		_floor.shapes.add(new Polygon(Polygon.rect(0, Browser.window.innerHeight, Browser.window.innerWidth, 1)));
		_floor.space = _space;
	}

	function _addBall() {
		var ball:Sprite = new Sprite(loader.getTexture(AssetsList.NAPE_BALL));
		ball.anchor.set(0.5);
		_balls.push(ball);
		_container.addChild(ball);

		var pball:Body = new Body(BodyType.DYNAMIC);
		pball.shapes.add(new Circle(10));
		pball.position.setxy(Std.random(800), 0);
		pball.angularVel = 0;
		pball.allowRotation = true;

		pball.setShapeMaterials(Material.rubber());
		pball.space = _space;
		_pballs.push(pball);
	}

	public function end() {
		_container.removeChildren();
		if (_timer != null) _timer.stop();
		if (Main.update != null) Main.update.remove(_update);
	}

	function _update(elapsedTime:Float) {
		_space.step(1 / 60);
		for (i in 0 ... _pballs.length) {
			_balls[i].position.x = _pballs[i].position.x;
			_balls[i].position.y = _pballs[i].position.y;
			_balls[i].rotation = _pballs[i].rotation;
		}
	}
}