package workers;

import js.html.XMLHttpRequest;
import haxe.Timer;

@:keep class VideoSubtitles {

	public static inline var START:String = "START";
	public static inline var DATA:String = "DATA";

	public static inline var VIDEO_PLAYLIST:String = "playlist.m3u8";
	public static inline var VIDEO_TABLE_PREFIX:String = "amlst:";

	public static function __init__() {
		untyped __js__("self.onmessage = workers_VideoSubtitles.prototype.messageHandler");
	}

	public function messageHandler(event) {
		var data:WorkerData = event.data;
		switch data.name {
			case START:
				var videoBaseUrl:String = data.value[0];
				var tableId:String = data.value[1];
				var currentGameReference:Float = null;
				var currentGameState:Float = null;
				var movie:String = null;
				var subtitlePlaylistUrl:String = null;
				var videoData:Array<Float> = [];

				var error = function() {
					untyped __js__("self").postMessage({ name: DATA, value: null });
				}

				// Extract webvtt file and load data from it - ex: http://93.93.85.123:1935/live/2_400_400_750000/subtitlechunk_leng_w813876404_2436.webvtt
				var getSubtitleData = function() {
					var data:Array<Float> = [];
					var subtitleRequest = new XMLHttpRequest();
					var subtitlePlaylistRequest = new XMLHttpRequest();

					subtitlePlaylistRequest.open("GET", subtitlePlaylistUrl, true);
					subtitlePlaylistRequest.send(null);
					//trace("SUBTITLE PLAYLIST: " + subtitlePlaylistUrl);

					subtitlePlaylistRequest.onreadystatechange = function() {
						if (subtitlePlaylistRequest.readyState == 4) {
							if (subtitlePlaylistRequest.status == 200) {
								var chunk:EReg = ~/subtitlechunk_.+webvtt/i;
								if (chunk.match(subtitlePlaylistRequest.responseText)) {
									subtitleRequest.open("GET", videoBaseUrl + movie + "/" + chunk.matched(0), true);
									subtitleRequest.send(null);
									//trace("SUBTITLE WEBVTT: " + videoBaseUrl + movie + "/" + chunk.matched(0));
								}
								else error();
							}
							else error();
						}
					}

					subtitleRequest.onreadystatechange = function() {
						if (subtitleRequest.readyState == 4) {
							if (subtitleRequest.status == 200) {
								var subtitles:EReg = ~/[0-9]+ [0-9]+ ?.+/i;
								if (subtitles.match(subtitleRequest.responseText)) {
									var cue:Array<String> = subtitles.matched(0).split(" ");
									var videoData = [for (val in cue) Std.parseFloat(val)];
									if (videoData.length > 0 && videoData[0] > 0) {
										if (currentGameReference != videoData[0] || currentGameState != videoData[2]) {
											currentGameReference = videoData[0];
											currentGameState = videoData[2];
											untyped __js__("self").postMessage({ name: DATA, value: videoData });
										}
									}
								}
							}
							else error();
						}
					}
				}

				// Extract URI and construct playlist url - ex: http://93.93.85.123:1935/live/2_400_400_750000/subtitlelist_leng_w813876404.m3u8
				var loadSubTitleData = function() {
					var request = new XMLHttpRequest();
					request.onreadystatechange = function() {
						if (request.readyState == 4) {
							if (request.status == 200) {
								var uri:EReg = ~/subtitlelist_.+m3u8/i;
								if (uri.match(request.responseText)) {
									subtitlePlaylistUrl = videoBaseUrl + movie + "/" + uri.matched(0);
									var timer = new Timer(1000);
									timer.run = getSubtitleData;
								}
								else error();
							}
							else error();
						}
					};

					request.open("GET", videoBaseUrl + movie + "/" + VIDEO_PLAYLIST, true);
					request.send(null);
					//trace("SUBTITLE URI: " + videoBaseUrl + movie + "/" + VIDEO_PLAYLIST);
				}

				// Construct subtitle url - ex: http://93.93.85.123:1935/live/2_400_400_750000/playlist.m3u8
				var request = new XMLHttpRequest();
				request.onreadystatechange = function() {
					if (request.readyState == 4) {
						if (request.status == 200) {
							var bw:EReg = ~/BANDWIDTH=[0-9]+/i;
							var res:EReg = ~/RESOLUTION=[0-9]+x[0-9]+/i;

							if (res.match(request.responseText)) {
								movie = tableId + "_" + StringTools.replace(res.matched(0).split("=")[1], "x", "_");
								if (bw.match(request.responseText)) movie += "_" + bw.matched(0).split("=")[1];
								loadSubTitleData();
							}
							else error();
						}
						else error();
					}
				}

				request.open("GET", videoBaseUrl + VIDEO_TABLE_PREFIX + tableId + "/" + VIDEO_PLAYLIST, true);
				request.send(null);
				//trace("SUBTITLE URL: " + videoBaseUrl + VIDEO_TABLE_PREFIX + tableId + "/" + VIDEO_PLAYLIST);
		}
	}
}

typedef WorkerData = {
	var name:String;
	@:optional var value:Dynamic;
}