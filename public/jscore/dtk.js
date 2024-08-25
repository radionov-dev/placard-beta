/**
 * Duotek Framework 2
 * JS Core
 */


function DTKController(widget,ident) {
	this.ident = ident;
	this.controller = widget;
	this.sign='';
	this.params={};
	this.dataSourceController=false;


	this._isElement = function(o) {
		return (
			typeof HTMLElement === "object" ? o instanceof HTMLElement : //DOM2
			o && typeof o === "object" && o !== null && o.nodeType === 1 && typeof o.nodeName === "string"
		);
	}

	this._isFunction = function(f) {
		var getType = {};
		return f && getType.toString.call(f) === '[object Function]';
	}

	this.callphp = function(method,arguments) {
		var initFunction = false;
		var callbackFunction = false;
		var dataSourceController = this.dataSourceController;


		if(this._isFunction(arguments[arguments.length-2])) {
			initFunction = arguments[arguments.length-2];
			delete arguments[arguments.length-2];
			callbackFunction = arguments[arguments.length-1];
			delete arguments[arguments.length-1];

		}

		if(this._isFunction(arguments[arguments.length-1])) {
			callbackFunction = arguments[arguments.length-1];
			delete arguments[arguments.length-1];
		}

		if(initFunction!=false) {
			initFunction();
		}

		var data = Object();
		data['controller'] = this.controller;
		data['ident'] = this.ident;

		data['method'] = method;
		data['params'] = this.params;

		data['sign'] = this.sign;



		var args = Array();

		for(var i=0;i<arguments.length;i++) {args[i]=arguments[i];}

		data['arguments'] = args;

		 document.body.style.cursor = 'wait';
		 Pace.track(function() {
			   $.ajax({
				   url: "/ajax.php",
				   method:'POST',
				   context: document.body,
				   data:data,
				 }).done(function(data) {
				  	 document.body.style.cursor = 'default';
				     if(dataSourceController == true) {
						 if(callbackFunction!=false) {
							 callbackFunction(data);
						 } else {
							return(data);
						 }
					 } else {
						 eval(data);
						 if(callbackFunction!=false) {
							 callbackFunction();
						 }
					 }

				 });
		 });
		 
			
	}
	
	this.setSign = function(sign) {
		this.sign=sign;
	}


}


function DTK() {
	this.windows=Object();

	this.loadWindow = function(controller, params, callback) {
		$.magnificPopup.open({
			type:'inline',
			showCloseBtn:false,
			items: {src:'<div id="__dtkwindow_'+controller+'" class="dtkpopup"></div>'} // TODO красивый загрузчик
		});

		this.loadWindowContent(controller, params, callback);
	}

	this.exceptionWindow = function() {
		$.magnificPopup.open({
			type:'inline',
			showCloseBtn:false,
			items: {src:'<div id="__dtkwindow_error" class="dtkpopup"></div>'}
		});

	}



	this.loadWindowContent = function(controller, params, callback) {
		document.body.style.cursor = 'wait';
		var data = Object();
		data['controller'] = controller;
		data['params'] = params;

		Pace.track(function () {
			$.ajax({
				url: "/window.php",
				method: 'POST',
				context: document.body,
				data: data,
			}).done(function (data) {
				eval(data);
				if (callback) callback;
				document.body.style.cursor = 'default';
			});
		});
	}

	this.closeWindow = function(controller) {
		$.magnificPopup.close();
	}

	this.showNotice = function(message, error) {
		$.jGrowl(message);
	}


	this.latin = function(str,path) {

		var abc1 = Object();
		abc1['1'] = '1';
		abc1['2'] = '2';
		abc1['3'] = '3';
		abc1['4'] = '4';
		abc1['5'] = '5';
		abc1['6'] = '6';
		abc1['7'] = '7';
		abc1['8'] = '8';
		abc1['9'] = '9';
		abc1['0'] = '0';
		abc1['q'] = 'q';
		abc1['w'] = 'w';
		abc1['e'] = 'e';
		abc1['r'] = 'r';
		abc1['t'] = 't';
		abc1['y'] = 'y';
		abc1['u'] = 'u';
		abc1['i'] = 'i';
		abc1['o'] = 'o';
		abc1['p'] = 'p';
		abc1['a'] = 'a';
		abc1['s'] = 's';
		abc1['d'] = 'd';
		abc1['f'] = 'f';
		abc1['g'] = 'g';
		abc1['h'] = 'h';
		abc1['j'] = 'j';
		abc1['k'] = 'k';
		abc1['l'] = 'l';
		abc1['z'] = 'z';
		abc1['x'] = 'x';
		abc1['c'] = 'c';
		abc1['v'] = 'v';
		abc1['b'] = 'b';
		abc1['n'] = 'n';
		abc1['m'] = 'm';
		abc1['Р°'] = 'a';
		abc1['Р±'] = 'b';
		abc1['РІ'] = 'v';
		abc1['Рі'] = 'g';
		abc1['Рґ'] = 'd';
		abc1['Рµ'] = 'e';
		abc1['С‘'] = 'jo';
		abc1['Р¶'] = 'zh';
		abc1['Р·'] = 'z';
		abc1['Рё'] = 'i';
		abc1['Р№'] = 'j';
		abc1['Рє'] = 'k';
		abc1['Р»'] = 'l';
		abc1['Рј'] = 'm';
		abc1['РЅ'] = 'n';
		abc1['Рѕ'] = 'o';
		abc1['Рї'] = 'p';
		abc1['СЂ'] = 'r';
		abc1['СЃ'] = 's';
		abc1['С‚'] = 't';
		abc1['Сѓ'] = 'u';
		abc1['С„'] = 'f';
		abc1['С…'] = 'h';
		abc1['С†'] = 'c';
		abc1['С‡'] = 'ch';
		abc1['С€'] = 'sh';
		abc1['С‰'] = 'sh';
		abc1['СЉ'] = '';
		abc1['С‹'] = 'y';
		abc1['СЊ'] = '';
		abc1['СЌ'] = 'e';
		abc1['СЋ'] = 'yu';
		abc1['СЏ'] = 'ya';
		abc1[' '] = '_';
		abc1['_'] = '_';


		if(path==true) {
			abc1['/'] = '/';
			abc1['-'] = '-';
		}

		str = str.toLowerCase();
		var newstr='';
		for(var i=0;i<str.length;i++) {
			if(abc1[str.substr(i,1)]!==false && abc1[str.substr(i,1)]!=undefined) {
				newstr=newstr+abc1[str.substr(i,1)];

			}
		}
		return newstr;
	}

	this.nums = function(str) {
		var abc1 = Object();
		abc1["0"] = "0";
		abc1["1"] = "1";
		abc1["2"] = "2";
		abc1["3"] = "3";
		abc1["4"] = "4";
		abc1["5"] = "5";
		abc1["6"] = "6";
		abc1["7"] = "7";
		abc1["8"] = "8";
		abc1["9"] = "9";

		abc1['.'] = '.';
		abc1[','] = '.';

		//str = str.toLowerCase();
		var newstr='';
		for(var i=0;i<str.length;i++) {
			if(abc1[str.substr(i,1)]!==false && abc1[str.substr(i,1)]!=undefined) {
				newstr=newstr+abc1[str.substr(i,1)];

			}
		}
		return newstr;
	}
}





/*function DTKWindow(controller,params,callback) {
	this.controller = controller;
	this.params = params;
	this.callback=callback;

	document.body.style.cursor = 'wait';

	this.loadContent = function() {
		document.body.style.cursor = 'wait';
		var data = Object();
		data['controller'] = this.controller;
		data['params'] = this.params;

		Pace.track(function() {
			$.ajax({
				url: "/window.php",
				method:'POST',
				context: document.body,
				data:data,
			}).done(function(data) {
				eval(data);
				if(this.callback) this.callback;
				document.body.style.cursor = 'default';
			});
		});
	}

	this.loadContent();

	this.close = function() {
		$.magnificPopup.close();
	}



	$.magnificPopup.open({
		type:'inline',
		showCloseBtn:false,
		items: {src:'<div id="__dtkwindow_'+controller+'" class="dtkpopup"></div>'} // TODO красивый загрузчик
	});

	window.DTKWindows[controller] = this;
}*/

$('.js-popup-image').magnificPopup({
	type: 'image',
	closeOnContentClick: true,
	closeBtnInside: false,
	fixedContentPos: true,
	image: {
		verticalFit: true
	},
	zoom: {
		enabled: true,
		duration: 300
	}
});


/** WEB SOCKETS **/
if(window.DTKConfig.websockets) {
	if ('WebSocket' in window) {
		var host = "ws://localhost:12345/websocket/server.php";
		try {
			socket = new WebSocket(host);
			log('WebSocket - status ' + socket.readyState);
			socket.onopen = function (msg) {
				log("Welcome - status " + this.readyState);
			};
			socket.onmessage = function (msg) {
				log("Received: " + msg.data);
			};
			socket.onclose = function (msg) {
				log("Disconnected - status " + this.readyState);
			};
		}
		catch (ex) {
			log(ex);
		}


	} else {
		/* WebSockets не поддерживаются. Надо использовать другой инструмент. Todo */
	}
}


window.DTK = new DTK();

