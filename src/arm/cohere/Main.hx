package arm.cohere;

import minject.Injector;
import arm.cohere.core.utils.BrowserUtils;
import arm.cohere.controller.Controller;
import arm.cohere.view.View;
import arm.cohere.model.Model;
import arm.cohere.core.utils.StageProperties;
import pixi.plugins.app.Application;
import js.Browser;
import pixi.core.Pixi;
import msignal.Signal.Signal0;
import msignal.Signal.Signal1;

class Main extends Application {

	public static var resize:Signal0;
	public static var update:Signal1<Float>;

	var _stageProperties:StageProperties;
	var _model:Model;
	var _view:View;
	var _controller:Controller;

	public function new() {
		super();
		_setStageProperties();
		_setScreenDimensions();
		_init();

		Pixi.RESOLUTION = _stageProperties.pixelRatio;
		super.start();
		_setupApplication();
	}

	inline function _setStageProperties() {
		_stageProperties = new StageProperties();
		_stageProperties.actualPixelRatio = Browser.window.devicePixelRatio;
		_stageProperties.pixelRatio = BrowserUtils.getPixelRatio();
	}

	inline function _setScreenDimensions() {
		_stageProperties.screenWidth = Browser.window.innerWidth;
		_stageProperties.screenHeight = Browser.window.innerHeight;
		_stageProperties.orientation = (_stageProperties.screenWidth > _stageProperties.screenHeight) ? StageProperties.LANDSCAPE : StageProperties.PORTRAIT;
	}

	inline function _init() {
		resize = new Signal0();
		update = new Signal1(Float);

		pixelRatio = _stageProperties.pixelRatio;
		backgroundColor = 0xFFFFFF;
		roundPixels = true;
		onUpdate = _onUpdate;
		onResize = _onResize;
		transparent = true;
	}

	inline function _setupApplication() {
		stage.interactive = true;

		_model = new Model();
		_model.updateFps.add(_onUpdateFps);
		_view = new View(stage);
		_controller = new Controller();

		var injector = new Injector();
		injector.mapValue(StageProperties, _stageProperties);
		injector.mapValue(Model, _model);
		injector.mapValue(View, _view);
		injector.injectInto(_controller);

		_controller.init();
	}

	function _onUpdateFps(val:Int) {
		if (val > 0) fps = val;
	}

	function _onUpdate(time:Float) {
		update.dispatch(time);
	}

	function _onResize() {
		_setScreenDimensions();
		resize.dispatch();
	}

	static function main() {
		new Main();
	}
}