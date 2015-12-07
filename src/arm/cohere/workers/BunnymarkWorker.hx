package arm.cohere.workers;

@:keep class BunnymarkWorker {

	static inline var BLOCK_AMOUNT:Int = 100;

	public static function __init__() {
		untyped __js__("self.onmessage = arm_cohere_workers_BunnymarkWorker.prototype._messageHandler");
	}

	function _messageHandler(event) {
		switch (event.data.name) {
			case "INIT":
				var data:BunnyData;
				var bunnyData:Array<BunnyData> = [];
				for (i in 0 ... BLOCK_AMOUNT) {
					data = {};
					data.speedX = Math.random() * 5;
					data.speedY = (Math.random() * 5) - 3;
					data.anchor = { x: 0, y: 1 };
					data.alpha = 0.3 + Math.random() * 0.7;
					data.scale = { x: 0.5 + Math.random() * 0.5, y: 0.5 + Math.random() * 0.5 };
					data.rotation = (Math.random() - 0.5);

					bunnyData.push(data);
				}

				untyped __js__("self").postMessage({ name: "INIT", value: bunnyData });

			case "MOVE":
				var data:BunnyData = event.data.value;

				if (data.position.x > data.maxX) {
					data.speedX *= -1;
					data.position.x = data.maxX;
				}
				else if (data.position.x < 0) {
					data.speedX *= -1;
					data.position.x = 0;
				}

				if (data.position.y > data.maxY) {
					data.speedY *= -0.85;
					data.position.y = data.maxY;
					if (Math.random() > 0.5) data.speedY -= Math.random() * 6;
				}
				else if (data.position.y < 0) {
					data.speedY = 0;
					data.position.y = 0;
				}

				untyped __js__("self").postMessage({ name: "MOVE", value: data });
		}

	}
}

typedef BunnyData = {
	@:optional var index:Int;
	@:optional var position:Point;
	@:optional var scale:Point;
	@:optional var anchor:Point;
	@:optional var rotation:Float;
	@:optional var alpha:Float;
	@:optional var speedX:Float;
	@:optional var speedY:Float;
	@:optional var maxX:Float;
	@:optional var maxY:Float;
}

typedef Point = {
	var x:Float;
	var y:Float;
}