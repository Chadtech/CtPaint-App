PaintApp = function(Client, flags) {
    console.log()

    Client.attributes(Client.getUser().username, function(err, result) {
        console.log(result);
        console.log(err);
    })

    function listenToKeyEvents (keydown, keyup) {
        window.addEventListener("keydown", keydown);
        window.addEventListener("keyup", keyup);
    }

    function ignoreKeyEvents (keydown, keyup) {
        window.removeEventListener("keydown", keydown);
        window.removeEventListener("keyup", keyup);
    }

    window.onbeforeunload = function(event) { return ""; };

    var app = Elm.PaintApp.fullscreen(flags);

    function makeKeyHandler (direction) {
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

    function jsMsgHandler(msg) {
        switch (msg.type) {
            case "save":
                localStorage.setItem("canvas", JSON.stringify(msg.payload));
                break;

            case "steal focus":
                ignoreKeyEvents(handleKeyDown, handleKeyUp);
                break;

            case "return focus":
                listenToKeyEvents(handleKeyDown, handleKeyUp);
                break;

            case "download":
                var canvas = document.getElementById("main-canvas");
                var png = canvas.toDataURL();

                var a = document.createElement("a");
                a.href = png;
                a.download = msg.payload;
                a.click();
                break;

            case "attempt login":
                Client.login(msg.payload, {
                    onSuccess: function(result) {
                        console.log(result);
                        Client.getUser().getUserAttributes(function(err, result) {
                            if (err) {
                                alert(err);
                                return;
                            }
                            for (i = 0; i < result.length; i++) {
                                console.log('attribute ' + result[i].getName() + ' has value ' + result[i].getValue());
                            }
                        })
                    },
                    onFailure: function(err) {
                        app.ports.fromJs.send({
                            type: "login failed",
                            payload: String(err)
                        })
                        console.log(err);
                    }
                });
                break;

            default:
                console.log("Unrecognized JsMsg type ->", msg.type);
                break;
        }
    }

    app.ports.toJs.subscribe(jsMsgHandler);
};
