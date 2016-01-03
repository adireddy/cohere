import sys.io.FileInput;
import haxe.Json;
import sys.io.FileOutput;
import sys.FileSystem;
import sys.io.File;

class Assets {

	var folders:Array<String> = [];
	var files:Array<String> = [];

	var _assetsFile:FileOutput;
	var _fileNames:Map<String, String>;
	var _fileIDs:Map<String, String>;
	var _spriteSheetIDs:Map<String, String>;

	public function new() {
		_fileNames = new Map();
		_fileIDs = new Map();
		_spriteSheetIDs = new Map();
		_assetsFile = File.write("utils/AssetsList.hx", false);
		_assetsFile.writeString("class AssetsList {\n\n");

		_assetsFile.writeString("\tstatic var LIST:Array<String> = [");

		_listFiles("assets");

		_assetsFile.writeString("\"\"];\n\n");

		for (file in _fileNames.keys()) _assetsFile.writeString("\tpublic static inline var " + file + ":String = \"" + _fileNames.get(file) + "\";\n");

		for (id in _fileIDs.keys()) _assetsFile.writeString("\tpublic static inline var " + id + ":String = \"" + _fileIDs.get(id) + "\";\n");

		for (id in _spriteSheetIDs.keys()) _assetsFile.writeString("\tpublic static inline var " + id + ":String = \"" + _spriteSheetIDs.get(id) + "\";\n");

		_assetsFile.writeString("\n\tpublic static function exists(val:String):Bool {\n");
		_assetsFile.writeString("\t\treturn (AssetsList.LIST.indexOf(val) > -1);\n");
		_assetsFile.writeString("\t}");

		_assetsFile.writeString("\n}");

		_assetsFile.close();
	}

	function _listFiles(name:String) {
		var files = FileSystem.readDirectory(name);
		for (f in files) {
			if (FileSystem.isDirectory(name + "/" + f)) folders.push(name + "/" + f);
			else {
				_assetsFile.writeString("\"" + name + "/" + f + "\",\n\t\t\t");
				_setFilesMap(name + "/" + f);
			}
		}

		if(folders.length > 0) {
			_listFiles(folders.shift());
		}
	}

	function _setFilesMap(name:String) {
		var filePath:String = "";
		var fileName:String = "";

		if (name.indexOf("json") > -1) _checkJson(name);

		if (name.indexOf(".DS_Store") == -1) {
			if (name.indexOf("@1x") > 0) filePath = name.substring(name.indexOf("@1x") + 4, name.length);
			else if (name.indexOf("sounds") > 0) filePath = name.substring(name.indexOf("sounds"), name.length);

			if (filePath != "") {
				fileName = filePath.split("/").join("_");
				fileName = fileName.split("-").join("_");
				//fileName = fileName.split("x").join("_");
				fileName = fileName.split(".").join("_");
				_fileNames.set(fileName.toUpperCase(), filePath);

				fileName = fileName.substring(0, fileName.lastIndexOf("_"));
				_fileIDs.set(fileName.toUpperCase(), fileName);
			}
		}
	}

	function _checkJson(file:String) {
		var data:String = sys.io.File.getContent(file);
		try {
			Json.parse(data);
		}
		catch (e:Dynamic) {
			Sys.println("\033[0m\033[91mInvalid Json: " + file + " - " + e + "\033[0m");
			Sys.exit(1);
		}

		if (file.indexOf("@1x") > 0) {
			var folder = file.substring(file.indexOf("@1x") + 4, file.lastIndexOf("."));
			var regex:EReg = ~/["A-Z0-9_-]+.png":/i;

			var fin = sys.io.File.read(file, false);
			try {
				var lineNum = 0;
				while(true) {
					var str:String = fin.readLine();
					var varName:String;
					if (regex.match(str)) {
						str = str.substring(str.indexOf("\"") + 1, str.lastIndexOf("\""));
						varName = folder + "_" + str.substring(0, str.lastIndexOf("."));
						varName = varName.split("/").join("_");
						varName = varName.split("-").join("_");
						varName = varName.split(".").join("_");
						varName = varName.split(" ").join("_");

						_spriteSheetIDs.set(varName.toUpperCase(), str);
					}
				}
			}
			catch(ex:haxe.io.Eof) {}
			fin.close();
		}
	}

	static function main() {
		new Assets();
	}
}