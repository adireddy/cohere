package extras;

import chart.data.SegmentData;
import js.html.DivElement;
import haxe.Json;
import haxe.Http;
import js.Browser;
import js.html.CanvasRenderingContext2D;
import js.html.CanvasElement;
import chart.Chart;

class FileSizeReportReader {

	var jsonData:DataFormat;

	var data = [
		{
			value: 300,
			color:"#F7464A",
			highlight: "#FF5A5E",
			label: "Red"
		},
		{
			value: 50,
			color: "#46BFBD",
			highlight: "#5AD3D1",
			label: "Green"
		},
		{
			value: 100,
			color: "#FDB45C",
			highlight: "#FFC870",
			label: "Yellow"
		}
	];

	public function new() {
		var request:Http = new Http("data.json");
		request.request(false);
		request.onData = _processData;

		//Global.responsive = true;
	}

	function _processData(response:String) {
		jsonData = Json.parse(response);

		_addStat("<u>Date</u>", jsonData.date);
		_addStat("<br/>");

		_addStat("<u>CODE</u>");
		_addStat("JS Dev", _stripDecimals(jsonData.jsDev / 1000 / 1000) + " MB");
		_addStat("JS Min (with libs)", _stripDecimals(jsonData.jsMin / 1000 / 1000) + " MB");

		_addStat("<br/>");
		_addStat("<u>FILE COUNT</u>");
		_addStat("Audio", jsonData.audioCount + " files");
		_addStat("Resources", jsonData.scale1Count + " files");

		_addStat("<br/>");
		_addStat("<u>SIZE</u>");
		_addStat("Audio", _stripDecimals(jsonData.audioSize / 1000 / 1000) + " MB");
		_addStat("Scale 1", _stripDecimals(jsonData.scale1Size / 1000 / 1000) + " MB");
		_addStat("Scale 2", _stripDecimals(jsonData.scale2Size / 1000 / 1000) + " MB");
		_addStat("<br/>");
		_addStat("Project Size (Scale 1)", _stripDecimals(jsonData.projectScale1Size / 1000 / 1000) + " MB");
		_addStat("Project Size (Scale 2)", _stripDecimals(jsonData.projectScale2Size / 1000 / 1000) + " MB");
		_addStat("<br/>");
		_addStat("Static Analysis", jsonData.checkstyleRules + " rules");

		var canvas:CanvasElement = Browser.document.createCanvasElement();
		canvas.style.position = "absolute";
		canvas.style.top = "20px";
		canvas.style.left = "150px";
		canvas.style.width = "960px";
		canvas.style.width = "640px";
		Browser.document.body.appendChild(canvas);

		var legend:DivElement = Browser.document.createDivElement();
		legend.style.position = "absolute";
		legend.style.top = "20px";
		legend.style.left = "600px";
		legend.style.fontFamily = "Helvetica,Arial";
		legend.style.padding = "2px";
		legend.style.color = "#003366";
		legend.style.fontSize = "14px";
		legend.style.fontWeight = "bold";
		Browser.document.body.appendChild(legend);

		var _data:Array<SegmentData> = [];
		_data.push(
			{
				value: _stripDecimals(jsonData.audioSize / 1000 / 1000),
				color:"#F7464A",
				highlight: "#FF5A5E",
				label: "Audio"
			}
		);

		_data.push(
			{
				value: _stripDecimals(jsonData.scale1Size / 1000 / 1000),
				color:"#46BFBD",
				highlight: "#5AD3D1",
				label: "Scale 1"
			}
		);

		_data.push(
			{
				value: _stripDecimals(jsonData.scale2Size / 1000 / 1000),
				color:"#FDB45C",
				highlight: "#FFC870",
				label: "Scale 2"
			}
		);

		_data.push(
			{
				value: _stripDecimals(jsonData.jsMin / 1000 / 1000),
				color:"#003366",
				highlight: "#003399",
				label: "Code"
			}
		);

		var ctx:CanvasRenderingContext2D = canvas.getContext("2d");
		var barChart = new Chart(ctx).Pie(_data);

		legend.innerHTML = barChart.generateLegend();
	}

	function _addStat(?title:String, ?val:String) {
		var ren:DivElement = Browser.document.createDivElement();
		ren.style.width = "250px";
		ren.style.background = "#CCCCC";
		ren.style.backgroundColor = "#105CB6";
		ren.style.fontFamily = "Helvetica,Arial";
		ren.style.padding = "2px";
		ren.style.color = "#0FF";
		ren.style.fontSize = "14px";
		ren.style.fontWeight = "bold";
		ren.style.textAlign = "left";
		Browser.document.body.appendChild(ren);
		ren.innerHTML = (val != null) ? title + ": " + val : title;
	}

	function _stripDecimals(val:Float):Float {
		var v = Std.string(val);
		if (v.indexOf(".") > -1) return Std.parseFloat(v.substring(0, v.indexOf(".") + 3));
		return val;
	}

	static function main() {
		new FileSizeReportReader();
	}
}

typedef DataFormat = {
	var date:String;
	var jsDev:Int;
	var jsMin:Int;
	var libCount:Int;
	var libSize:Int;
	var scale1Count:Int;
	var scale1Size:Int;
	var scale2Count:Int;
	var scale2Size:Int;
	var audioCount:Int;
	var audioSize:Int;
	var miscSize:Int;
	var projectScale1Size:Int;
	var projectScale2Size:Int;
	var checkstyleRules:Int;
}