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
    if (payload.id === null) {
        createDrawing(Client, toElm, payload);
    } else {
        updateDrawing(Client, toElm, payload);
    }
}

function createDrawing(Client, toElm, payload) {
    Client.createDrawing(payload, {
        onSuccess: function(result) {
            toElm("drawing create completd", result);
        },
        onFailure: function(err) {
            toElm("drawing create completed", String(err));
        }
    });
}

function updateDrawing(Client, toElm, payload) {
    Client.updateDrawing(payload, {
        onSuccess: function(result) {
            var code = toCode(result);
            toElm("drawing update completed", code);
        },
        onFailure: function(err) {
            toElm("drawing update completed", String(err));
        }
    });
}


function toCode(result) {
    if (result.data) {
        return String(result.data.statusCode);
    }
    return null;
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
