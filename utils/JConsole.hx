class JConsole {

	#if debug
	static var lastFileName:String;
	static var clrs:Array<String> = ["green", "blue", "hotpink", "darkorange", "indigo", "brown", "olive", "blueviolet", "teal", "darkmagenta", "darkcyan"];
	static var index:Int = 0;
	#end

	public static function log(msg:Dynamic) {
		#if debug untyped __js__("console").log(msg); #end
	}

	public static function info(msg:Dynamic) {
		#if debug untyped __js__("console").info(msg); #end
	}

	public static function warn(msg:Dynamic) {
		#if debug untyped __js__("console").warn(msg); #end
	}

	public static function error(msg:Dynamic) {
		#if debug untyped __js__("console").error(msg); #end
	}

	public static function trace(msg:Dynamic, ?inf:haxe.PosInfos) {
		#if debug
		if (lastFileName != inf.fileName) index++;
		if (index == clrs.length) index = 0;
		lastFileName = inf.fileName;
		if (inf != null && inf.customParams != null) for(v in inf.customParams ) msg += " " + v;
		untyped __js__("console").log("%c" + inf.fileName + "(" + inf.methodName + ":" + inf.lineNumber + ") " + msg, "color: " + clrs[index]+ ";font-weight:bold;");
		#end
	}
}