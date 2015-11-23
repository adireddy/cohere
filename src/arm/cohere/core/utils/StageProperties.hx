package arm.cohere.core.utils;

class StageProperties {

	public static inline var LANDSCAPE:String = "LANDSCAPE";
	public static inline var PORTRAIT:String = "PORTRAIT";

	public static inline var BUCKET_OVERLAP_FULL:String = "BUCKET_OVERLAP_FULL";
	public static inline var BUCKET_OVERLAP_HORIZONTAL:String = "BUCKET_OVERLAP_HORIZONTAL";
	public static inline var BUCKET_OVERLAP_VERTICAL:String = "BUCKET_OVERLAP_VERTICAL";

	public var actualPixelRatio:Float;
	public var pixelRatio:Float;
	public var screenWidth:Float;
	public var screenHeight:Float;
	public var bucketWidth:Float;
	public var bucketHeight:Float;
	public var screenX:Float;
	public var screenY:Float;
	public var orientation:String;
	public var bucketOverlapType:String;

	public function new() {
		pixelRatio = 1;
		screenWidth = 1024;
		screenHeight = 768;
		bucketWidth = 1024;
		bucketHeight = 768;
		screenX = 0;
		screenY = 0;
	}
}