/*
	init
		null
		{ id : String }
		{ url : String }
		{ params :
			{ width : Int optional
			, height : Int optional
			, name : String optional
			, backgroundcolor : "Black" | "White" optional
			}
		}

	manifest
		{ init : init
		, Client : Client
		, track : Tracking Function
		, mountPath : String
		, buildNumber : Int
		}
*/

var Flags = require("./Js/Flags");

PaintApp = function(manifest) {
	var Client = manifest.Client;
	var track = manifest.track;
	var app = { elm: null };

	function toElm(type, payload) {
		app.elm.ports.fromJs.send({
			type: type,
			payload: payload
		});
	}

	var Drawing = require("./Js/Drawing")(Client, toElm);
	var User = require("./Js/User")(Client, toElm);
	var Keys = require("./Js/Keys")(app);
	var Upload = require("./Js/Upload")(toElm);

	function redirectPageTo(payload) {
		window.onbeforeunload = null;
		window.location = payload;
	}

	var actions = {
		save: Drawing.save,
		stealFocus: Keys.ignoreEvents,
		returnFocus: Keys.listenToEvents,
		download: Drawing.download,
		attemptLogin: User.login,
		logout: User.logout,
		openNewWindow: window.open,
		redirectPageTo: redirectPageTo,
		openUpFileUpload: Upload,
		loadDrawing: Drawing.get,
		track: track
	};

	function jsMsgHandler(msg) {
		var action = actions[msg.type];
		if (typeof action === "undefined") {
			console.log("Unrecognized JsMsg type ->", msg.type);
			return;
		}
		action(msg.payload);
	}

	User.get(function(user) {
		var inithtml = document.getElementById("inithtml");
		if (inithtml !== null) {
			document.body.removeChild(inithtml);
		}
		Keys.listenToEvents();
		app.elm = Elm.PaintApp.fullscreen(Flags.make(user, manifest));
		app.elm.ports.toJs.subscribe(jsMsgHandler);
	});
};
