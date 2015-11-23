package extras;

import haxe.Json;
import sys.FileStat;
import sys.io.FileOutput;
import sys.FileSystem;
import sys.io.File;

class FileSizeReport {

	var _reportFile:FileOutput;
	var _fileCount:Int;
	var _fileSize:Int;
	var _folders:Array<String>;

	var _codeSize:Int;
	var _audioSize:Int;
	var _scale1Size:Int;
	var _scale2Size:Int;
	var _miscFilesSize:Int;

	static inline var JS_DEV:String = "js/cohere.dev.js";
	static inline var JS_MIN:String = "js/cohere.min.js";
	static inline var SCALE1_FOLDER:String = "resources/@1x";
	static inline var SCALE2_FOLDER:String = "resources/@2x";
	static inline var SOUNDS_FOLDER:String = "resources/sounds";

	static inline var OUTPUT:String = "reports/sizereport/data.json";

	static inline var CHECKSTYLE_RULES:String = "utils/checkstyle_config.json";

	public function new() {
		_miscFilesSize = 0;

		_reportFile = File.write(OUTPUT, false);
		_reportFile.writeString("{\n");

		_jsReport();
		_fileCountReport();
		_miscFilesReport();

		var data:String = sys.io.File.getContent(CHECKSTYLE_RULES);
		try {
			var rules = Json.parse(data);
			_reportFile.writeString(",\n\t\"checkstyleRules\": " + rules.checks.length);

		}
		catch (e:Dynamic) {}

		_reportFile.writeString("\n}");
	}

	inline function _jsReport() {
		var file:FileStat = FileSystem.stat(JS_DEV);
		_reportFile.writeString("\t\"date\": \"" + Date.now() + "\",\n");
		_reportFile.writeString("\t\"jsDev\": " + file.size + ",\n");

		file = FileSystem.stat(JS_MIN);
		_codeSize = file.size;
		_reportFile.writeString("\t\"jsMin\": " + file.size + ",\n");
	}

	inline function _fileCountReport() {
		var data:Array<Int>;
		_reset();

		_reset();
		data = _getRecursiveFileCount(SCALE1_FOLDER);
		_scale1Size = data[1];
		_reportFile.writeString("\t\"scale1Count\": " + data[0] + ",\n");
		_reportFile.writeString("\t\"scale1Size\": " + data[1] + ",\n");

		_reset();
		data = _getRecursiveFileCount(SCALE2_FOLDER);
		_scale2Size = data[1];
		_reportFile.writeString("\t\"scale2Count\": " + data[0] + ",\n");
		_reportFile.writeString("\t\"scale2Size\": " + data[1] + ",\n");

		_reset();
		data = _getRecursiveFileCount(SOUNDS_FOLDER);
		_audioSize = data[1];
		_reportFile.writeString("\t\"audioCount\": " + data[0] + ",\n");
		_reportFile.writeString("\t\"audioSize\": " + data[1] + ",\n");
	}

	inline function _miscFilesReport() {
		//_miscFilesSize += _getFileSize(FILE);
		_reportFile.writeString("\t\"miscSize\": " + _miscFilesSize + ",\n");

		var size = _codeSize + _audioSize + _miscFilesSize;
		_reportFile.writeString("\t\"projectScale1Size\": " + (size + _scale1Size) + ",\n");
		_reportFile.writeString("\t\"projectScale2Size\": " + (size + _scale2Size));
	}

	function _getRecursiveFileCount(name:String):Array<Int> {
		var files = FileSystem.readDirectory(name);
		for (f in files) {
			if (FileSystem.isDirectory(name + "/" + f)) _folders.push(name + "/" + f);
			else {
				_fileCount++;
				_fileSize += FileSystem.stat(name + "/" + f).size;
			}
		}

		if(_folders.length > 0) {
			_getRecursiveFileCount(_folders.shift());
		}
		return [_fileCount, _fileSize];
	}

	function _getFileSize(path:String):Int {
		return FileSystem.stat(path).size;
	}

	function _reset() {
		_fileCount = 0;
		_fileSize = 0;
		_folders = [];
	}

	static function main() {
		new FileSizeReport();
	}
}