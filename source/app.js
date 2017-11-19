PaintApp = function(Client) {

    function flags(extraFlags){
        return {
          windowHeight: window.innerHeight,
          windowWidth: window.innerWidth,
          seed: Math.round(Math.random() * 999999999999),
          isMac: (window.navigator.userAgent.indexOf("Mac")) !== -1,
          isChrome: (window.navigator.userAgent.indexOf("Chrome")) !== -1,
          user: extraFlags.user
        };
    }


    function listenToKeyEvents (keydown, keyup) {
        window.addEventListener("keydown", keydown);
        window.addEventListener("keyup", keyup);
    }

    function ignoreKeyEvents (keydown, keyup) {
        window.removeEventListener("keydown", keydown);
        window.removeEventListener("keyup", keyup);
    }

    window.onbeforeunload = function(event) { return ""; };

    function toUser(attributes) {
        var payload = {};

        for (i = 0; i < attributes.length; i++) {
            payload[ attributes[i].getName() ] = attributes[i].getValue();
        }

        return payload;
    }

    var app;

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

    function handleLogin(user) {
        user.getUserAttributes(function(err, attributes) {
            if (err) {
                app.ports.fromJs.send({
                    type: "login failed",
                    payload: String(err)
                });
            } else {
                app.ports.fromJs.send({
                    type: "login succeeded",
                    payload: toUser(attributes)
                });
            }
        });
    }

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
                    onSuccess: handleLogin,
                    onFailure: function(err) {
                        app.ports.fromJs.send({
                            type: "login failed",
                            payload: String(err)
                        })
                    }
                });
                break;

            case "logout":
                function succeed(){
                    app.ports.fromJs.send({
                        type: "logout succeeded",
                        payload: null
                    });
                }

                Client.logout({
                    onSuccess: succeed,
                    onFailure: function(err) {
                        switch (err) {
                            case "user was not signed in":
                                succeed();
                                break;

                            default:
                                app.ports.fromJs.send({
                                    type: "logout failed",
                                    payload: err
                                });
                                break;
                        }
                    }
                });
                break;

            default:
                console.log("Unrecognized JsMsg type ->", msg.type);
                break;
        }
    }

    function init(extraFlags) {
        app = Elm.PaintApp.fullscreen(flags(extraFlags));
        app.ports.toJs.subscribe(jsMsgHandler);
    }

    Client.getSession({
        onSuccess: function(attributes) {
            init({
                user: toUser(attributes)
            });
        },
        onFailure: function(err) {
            switch (err) {
                case "no session" :
                    init({ user: null });
                    break;

                case "NetworkingError: Network Failure":
                    init({ user: null });
                    break;

                default : 
                    console.log("Unknown get session error", err);
            }
        }
    });
};
