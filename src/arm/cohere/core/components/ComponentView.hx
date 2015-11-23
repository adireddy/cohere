package arm.cohere.core.components;

import arm.cohere.view.View;
import arm.cohere.core.utils.StageProperties;
import arm.cohere.core.loader.AssetLoader;
import pixi.core.display.Container;

@SuppressWarnings("checkstyle:Dynamic")
@:keepSub class ComponentView {

	@inject public var loader:AssetLoader;
	@inject public var stageProperties:StageProperties;

	var _container:Container;

	public var componentName:String;

	public var view(default, null):View;

	public var index(default, default):Int;

	public function new(mainView:View, viewName:String) {
		view = mainView;

		_container = new Container();
		_container.name = viewName + "Container";

		componentName = viewName.substring(0, viewName.indexOf("View")).toLowerCase();

		if (Main.resize != null) Main.resize.add(resize);
		if (Main.update != null) Main.update.add(update);
	}

	public inline function show() {
		_container.visible = true;
	}

	public inline function hide() {
		_container.visible = false;
	}

	public function init() {
		view.stage.addChild(_container);
	}

	public function addAssetsToLoad() {}

	public function resize() {}

	public function destroy() {
		_container.destroy(true);
		view.stage.removeChild(_container);
		_container = null;
	}

	public function update(t:Float) {}

	public function applyIndex() {
		if (index != null && index <= view.stage.children.length - 1) view.stage.setChildIndex(_container, index);
		else {
			index = view.stage.children.length - 1;
			view.stage.setChildIndex(_container, index);
		}
	}
}