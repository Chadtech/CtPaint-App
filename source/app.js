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

var Allowance = require("./Js/Allowance");
var Flags = require("./Js/Flags");

PaintApp = function(manifest) {
	var Client = manifest.Client;
	var track = manifest.track;
	var app;

	function toElm(type, payload) {
		app.ports.fromJs.send({
			type: type,
			payload: payload
		});
	}

	var Drawing = require("./Js/Drawing")(Client, toElm);
	var User = require("./Js/User")(Client, toElm);

	function listenToKeyEvents(keydown, keyup) {
		window.addEventListener("keydown", keydown);
		window.addEventListener("keyup", keyup);
	}

	function ignoreKeyEvents(keydown, keyup) {
		window.removeEventListener("keydown", keydown);
		window.removeEventListener("keyup", keyup);
	}

	window.onbeforeunload = function(event) {
		return "";
	};

	function makeKeyHandler(direction) {
		return function(event) {
			app.ports.keyEvent.send({
				keyCode: event.keyCode,
				shift: event.shiftKey,
				meta: event.metaKey,
				ctrl: event.ctrlKey,
				direction: direction
			});

			event.preventDefault();
		};
	}

	var handleKeyDown = makeKeyHandler("down");
	var handleKeyUp = makeKeyHandler("up");

	listenToKeyEvents(handleKeyDown, handleKeyUp);

	var fileUploader = document.createElement("input");
	fileUploader.type = "file";
	fileUploader.addEventListener("change", function(event) {
		var reader = new FileReader();

		reader.onload = function() {
			toElm("file read", reader.result);
		};

		var imageIndex = ["image/png", "image/jpeg"].indexOf(
			fileUploader.files[0].type
		);

		if (imageIndex !== -1) {
			reader.readAsDataURL(fileUploader.files[0]);
		} else {
			toElm("file not image", null);
		}
	});

	function action(type, f) {
		return {
			type: type,
			f: f
		};
	}

	var actions = [
		action("save", Drawing.save),
		action("steal focus", function() {
			ignoreKeyEvents(handleKeyDown, handleKeyUp);
		}),
		action("return focus", function() {
			listenToKeyEvents(handleKeyDown, handleKeyUp);
		}),
		action("download", Drawing.download),
		action("attempt login", User.login),
		action("logout", User.logout),
		action("open new window", window.open),
		action("redirect page to", function(payload) {
			window.onbeforeunload = null;
			window.location = payload;
		}),
		action("open up file upload", fileUploader.click),
		action("load drawing", Drawing.get),
		action("track", track)
	];

	function jsMsgHandler(msg) {
		for (var i = 0; i < actions.length; i++) {
			if (msg.type === actions[i].type) {
				actions[i].f(msg.payload);
				return;
			}
		}
		console.log("Unrecognized JsMsg type ->", msg.type);
	}

	function init(mixins) {
		var inithtml = document.getElementById("inithtml");
		if (inithtml !== null) {
			document.body.removeChild(inithtml);
		}
		app = Elm.PaintApp.fullscreen(Flags.make(mixins));
		app.ports.toJs.subscribe(jsMsgHandler);
	}

	Client.getSession({
		onSuccess: function(attrs) {
			init({
				user: User.fromAttributes(attrs),
				manifest: manifest
			});
		},
		onFailure: function(err) {
			if (Allowance.exceeded()) {
				err = "allowance exceeded";
			}
			switch (String(err)) {
				case "no session":
					init({
						user: null,
						manifest: manifest
					});
					break;

				case "NetworkingError: Network Failure":
					init({
						user: "offline",
						manifest: manifest
					});
					break;

				case "allowance exceeded":
					init({
						user: "allowance exceeded",
						manifest: manifest
					});
					break;

				default:
					console.log("Unknown get session error", err);
			}
		}
	});
};
