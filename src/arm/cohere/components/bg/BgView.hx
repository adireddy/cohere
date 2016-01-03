package arm.cohere.components.bg;

import arm.cohere.core.utils.BrowserUtils;
import arm.cohere.core.components.ComponentView;

class BgView extends ComponentView {

	override public function addAssetsToLoad() {
		loader.addAudioAsset(AssetsList.SOUNDS_BG, AssetsList.SOUNDS_BG_MP3);
	}

	public function playBgSound() {
		/*if (BrowserUtils.isiOS()) {
			Waud.enableTouchUnlock(function() {
				loader.playAudio(AssetsList.SOUNDS_BG, true);
			});
		}
		else loader.playAudio(AssetsList.SOUNDS_BG, true);*/
	}
}