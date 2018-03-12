/*
payload ==
	{ canvas : String 
	, palette : List String
	, swatches :
		{ top : String
		, left : String
		, right : String
		, bottom : String
		}
	, name : String
	, nameIsGenerated : Bool
	, email : String
	, id : Maybe String
	}
*/
function save(Client, toElm, payload) {
	console.log(payload);
	if (payload.id === null) {
		Client.createDrawing(payload, {
			onSuccess: function(result) {
				console.log("Result!", result);
			},
			onFailure: function(err) {
				console.log("Error!", err);
			}
		});
	} else {
		Client.updateDrawing(payload, {
			onSuccess: function(result) {
				console.log("Result!", result);
			},
			onFailure: function(err) {
				console.log("Error!", err);
			}
		});
	}
}

function get(Client, toElm, payload) {
	Client.getDrawing(payload, {
		onSuccess: function(result) {
			toElm("drawing loaded", result.data);
		},
		onFailure: function(error) {
			toElm("drawing failed to load", String(error));
		}
	});
}

function download(payload) {
	var canvas = document.getElementById("main-canvas");
	var png = canvas.toDataURL();

	var a = document.createElement("a");
	a.href = png;
	a.download = payload;
	a.click();
}

module.exports = function(Client, toElm) {
	return {
		save: function(payload) {
			save(Client, toElm, payload);
		},
		get: function(payload) {
			get(Client, toElm, payload);
		},
		download: download
	};
};
