(function (console) { "use strict";
function $extend(from, fields) {
	function Inherit() {} Inherit.prototype = from; var proto = new Inherit();
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var EReg = function(r,opt) {
	opt = opt.split("u").join("");
	this.r = new RegExp(r,opt);
};
EReg.prototype = {
	match: function(s) {
		if(this.r.global) this.r.lastIndex = 0;
		this.r.m = this.r.exec(s);
		this.r.s = s;
		return this.r.m != null;
	}
};
var Lambda = function() { };
Lambda.exists = function(it,f) {
	var $it0 = it.iterator();
	while( $it0.hasNext() ) {
		var x = $it0.next();
		if(f(x)) return true;
	}
	return false;
};
var List = function() {
	this.length = 0;
};
List.prototype = {
	iterator: function() {
		return new _$List_ListIterator(this.h);
	}
};
var _$List_ListIterator = function(head) {
	this.head = head;
	this.val = null;
};
_$List_ListIterator.prototype = {
	hasNext: function() {
		return this.head != null;
	}
	,next: function() {
		this.val = this.head[0];
		this.head = this.head[1];
		return this.val;
	}
};
var Std = function() { };
Std.parseFloat = function(x) {
	return parseFloat(x);
};
var extras_FileSizeReportReader = function() {
	this.data = [{ value : 300, color : "#F7464A", highlight : "#FF5A5E", label : "Red"},{ value : 50, color : "#46BFBD", highlight : "#5AD3D1", label : "Green"},{ value : 100, color : "#FDB45C", highlight : "#FFC870", label : "Yellow"}];
	var request = new haxe_Http("data.json");
	request.request(false);
	request.onData = $bind(this,this._processData);
};
extras_FileSizeReportReader.main = function() {
	new extras_FileSizeReportReader();
};
extras_FileSizeReportReader.prototype = {
	_processData: function(response) {
		this.jsonData = JSON.parse(response);
		this._addStat("<u>Date</u>",this.jsonData.date);
		this._addStat("<br/>");
		this._addStat("<u>CODE</u>");
		this._addStat("JS Dev",this._stripDecimals(this.jsonData.jsDev / 1000 / 1000) + " MB");
		this._addStat("JS Min (with libs)",this._stripDecimals(this.jsonData.jsMin / 1000 / 1000) + " MB");
		this._addStat("<br/>");
		this._addStat("<u>FILE COUNT</u>");
		this._addStat("Audio",this.jsonData.audioCount + " files");
		this._addStat("Resources",this.jsonData.scale1Count + " files");
		this._addStat("<br/>");
		this._addStat("<u>SIZE</u>");
		this._addStat("Audio",this._stripDecimals(this.jsonData.audioSize / 1000 / 1000) + " MB");
		this._addStat("Scale 1",this._stripDecimals(this.jsonData.scale1Size / 1000 / 1000) + " MB");
		this._addStat("Scale 2",this._stripDecimals(this.jsonData.scale2Size / 1000 / 1000) + " MB");
		this._addStat("<br/>");
		this._addStat("Project Size (Scale 1)",this._stripDecimals(this.jsonData.projectScale1Size / 1000 / 1000) + " MB");
		this._addStat("Project Size (Scale 2)",this._stripDecimals(this.jsonData.projectScale2Size / 1000 / 1000) + " MB");
		this._addStat("<br/>");
		this._addStat("Static Analysis",this.jsonData.checkstyleRules + " rules");
		var canvas;
		var _this = window.document;
		canvas = _this.createElement("canvas");
		canvas.style.position = "absolute";
		canvas.style.top = "20px";
		canvas.style.left = "150px";
		canvas.style.width = "960px";
		canvas.style.width = "640px";
		window.document.body.appendChild(canvas);
		var legend;
		var _this1 = window.document;
		legend = _this1.createElement("div");
		legend.style.position = "absolute";
		legend.style.top = "20px";
		legend.style.left = "600px";
		legend.style.fontFamily = "Helvetica,Arial";
		legend.style.padding = "2px";
		legend.style.color = "#003366";
		legend.style.fontSize = "14px";
		legend.style.fontWeight = "bold";
		window.document.body.appendChild(legend);
		var _data = [];
		_data.push({ value : this._stripDecimals(this.jsonData.audioSize / 1000 / 1000), color : "#F7464A", highlight : "#FF5A5E", label : "Audio"});
		_data.push({ value : this._stripDecimals(this.jsonData.scale1Size / 1000 / 1000), color : "#46BFBD", highlight : "#5AD3D1", label : "Scale 1"});
		_data.push({ value : this._stripDecimals(this.jsonData.scale2Size / 1000 / 1000), color : "#FDB45C", highlight : "#FFC870", label : "Scale 2"});
		_data.push({ value : this._stripDecimals(this.jsonData.jsMin / 1000 / 1000), color : "#003366", highlight : "#003399", label : "Code"});
		var ctx = canvas.getContext("2d");
		var barChart = new Chart(ctx).Pie(_data);
		legend.innerHTML = barChart.generateLegend();
	}
	,_addStat: function(title,val) {
		var ren;
		var _this = window.document;
		ren = _this.createElement("div");
		ren.style.width = "250px";
		ren.style.background = "#CCCCC";
		ren.style.backgroundColor = "#105CB6";
		ren.style.fontFamily = "Helvetica,Arial";
		ren.style.padding = "2px";
		ren.style.color = "#0FF";
		ren.style.fontSize = "14px";
		ren.style.fontWeight = "bold";
		ren.style.textAlign = "left";
		window.document.body.appendChild(ren);
		if(val != null) ren.innerHTML = title + ": " + val; else ren.innerHTML = title;
	}
	,_stripDecimals: function(val) {
		var v;
		if(val == null) v = "null"; else v = "" + val;
		if(v.indexOf(".") > -1) return Std.parseFloat(v.substring(0,v.indexOf(".") + 3));
		return val;
	}
};
var haxe_Http = function(url) {
	this.url = url;
	this.headers = new List();
	this.params = new List();
	this.async = true;
};
haxe_Http.prototype = {
	request: function(post) {
		var me = this;
		me.responseData = null;
		var r = this.req = js_Browser.createXMLHttpRequest();
		var onreadystatechange = function(_) {
			if(r.readyState != 4) return;
			var s;
			try {
				s = r.status;
			} catch( e ) {
				if (e instanceof js__$Boot_HaxeError) e = e.val;
				s = null;
			}
			if(s != null) {
				var protocol = window.location.protocol.toLowerCase();
				var rlocalProtocol = new EReg("^(?:about|app|app-storage|.+-extension|file|res|widget):$","");
				var isLocal = rlocalProtocol.match(protocol);
				if(isLocal) if(r.responseText != null) s = 200; else s = 404;
			}
			if(s == undefined) s = null;
			if(s != null) me.onStatus(s);
			if(s != null && s >= 200 && s < 400) {
				me.req = null;
				me.onData(me.responseData = r.responseText);
			} else if(s == null) {
				me.req = null;
				me.onError("Failed to connect or resolve host");
			} else switch(s) {
			case 12029:
				me.req = null;
				me.onError("Failed to connect to host");
				break;
			case 12007:
				me.req = null;
				me.onError("Unknown host");
				break;
			default:
				me.req = null;
				me.responseData = r.responseText;
				me.onError("Http Error #" + r.status);
			}
		};
		if(this.async) r.onreadystatechange = onreadystatechange;
		var uri = this.postData;
		if(uri != null) post = true; else {
			var _g_head = this.params.h;
			var _g_val = null;
			while(_g_head != null) {
				var p;
				p = (function($this) {
					var $r;
					_g_val = _g_head[0];
					_g_head = _g_head[1];
					$r = _g_val;
					return $r;
				}(this));
				if(uri == null) uri = ""; else uri += "&";
				uri += encodeURIComponent(p.param) + "=" + encodeURIComponent(p.value);
			}
		}
		try {
			if(post) r.open("POST",this.url,this.async); else if(uri != null) {
				var question = this.url.split("?").length <= 1;
				r.open("GET",this.url + (question?"?":"&") + uri,this.async);
				uri = null;
			} else r.open("GET",this.url,this.async);
		} catch( e1 ) {
			if (e1 instanceof js__$Boot_HaxeError) e1 = e1.val;
			me.req = null;
			this.onError(e1.toString());
			return;
		}
		if(!Lambda.exists(this.headers,function(h) {
			return h.header == "Content-Type";
		}) && post && this.postData == null) r.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		var _g_head1 = this.headers.h;
		var _g_val1 = null;
		while(_g_head1 != null) {
			var h1;
			h1 = (function($this) {
				var $r;
				_g_val1 = _g_head1[0];
				_g_head1 = _g_head1[1];
				$r = _g_val1;
				return $r;
			}(this));
			r.setRequestHeader(h1.header,h1.value);
		}
		r.send(uri);
		if(!this.async) onreadystatechange(null);
	}
	,onData: function(data) {
	}
	,onError: function(msg) {
	}
	,onStatus: function(status) {
	}
};
var js__$Boot_HaxeError = function(val) {
	Error.call(this);
	this.val = val;
	this.message = String(val);
	if(Error.captureStackTrace) Error.captureStackTrace(this,js__$Boot_HaxeError);
};
js__$Boot_HaxeError.__super__ = Error;
js__$Boot_HaxeError.prototype = $extend(Error.prototype,{
});
var js_Browser = function() { };
js_Browser.createXMLHttpRequest = function() {
	if(typeof XMLHttpRequest != "undefined") return new XMLHttpRequest();
	if(typeof ActiveXObject != "undefined") return new ActiveXObject("Microsoft.XMLHTTP");
	throw new js__$Boot_HaxeError("Unable to create XMLHttpRequest object.");
};
var $_, $fid = 0;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $fid++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = function(){ return f.method.apply(f.scope, arguments); }; f.scope = o; f.method = m; o.hx__closures__[m.__id__] = f; } return f; }
extras_FileSizeReportReader.main();
})(typeof console != "undefined" ? console : {log:function(){}});
