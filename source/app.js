/*
    initMsgs 
        { type : "init paint app" }
        { type : "init new drawing" }
        { type : "init drawing", payload: "id" }
        { type : "init image", payload: "url" }

    existing state
        null
        { data: String
        , width: Int
        , height: Int
        , project: 
            null
            { payload: Project }
        }

    user
        null
        "offline"
        User
        "allowance exceeded"

    manifest
        { initMsg: initMsg
        , Client: Client
        , mountPath: String
        }
*/

var Allowance = require("./Js/Allowance");
var User = require("./Js/User");
var Flags = require("./Js/Flags");

PaintApp = function(manifest) {
    var Client = manifest.Client;
    var track = manifest.track;


    var app;

    function listenToKeyEvents (keydown, keyup) {
        window.addEventListener("keydown", keydown);
        window.addEventListener("keyup", keyup);
    }

    function ignoreKeyEvents (keydown, keyup) {
        window.removeEventListener("keydown", keydown);
        window.removeEventListener("keyup", keyup);
    }

    window.onbeforeunload = function(event) { return ""; };

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
                    payload: User.fromAttributes(attributes)
                });
            }
        });
    }

    var fileUploader = document.createElement("input");
    fileUploader.type = "file";
    fileUploader.addEventListener("change", function(event) {
        var reader = new FileReader();
        
        reader.onload = function(){
            var dataURL = reader.result;
            app.ports.fromJs.send({
                type: "file read",
                payload: reader.result
            });
        };
        
        var imageIndex = [
            "image/png",
            "image/jpeg"
        ].indexOf(fileUploader.files[0].type);

        if (imageIndex !== -1) {
            reader.readAsDataURL(fileUploader.files[0]);
        } else {
            app.ports.fromJs.send({
                type: "file not image",
                payload: null
            });
        }
    })

    function jsMsgHandler(msg) {
        switch (msg.type) {
            case "save":
                localStorage.setItem("local state", JSON.stringify(msg.payload));

                var data = {
                    content: msg.payload.data,
                    attachments: "Yoink"
                };

                Client.createDrawing(data, {
                    onSuccess: function(result) {
                        console.log("Result!", result);
                    },
                    onFailure: function(err) {
                        console.log("Error!", err);
                    }
                });
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

            case "open new window":
                window.open(msg.payload);
                break;

            case "redirect page to":
                window.onbeforeunload = null;
                window.location = msg.payload;
                break;

            case "open up file upload":
                fileUploader.click();
                break;

            case "track": 
                track(msg.payload);
                break;

            default:
                console.log("Unrecognized JsMsg type ->", msg.type);
                break;
        }
    }

    function init(mixins) {
        app = Elm.PaintApp.fullscreen(Flags.make(mixins));
        app.ports.toJs.subscribe(jsMsgHandler);
    };

    Client.getSession({
        onSuccess: function(attributes) {
            // Client.getDrawing(User.fromAttributes(attributes).sub, {
            //     onFailure: function(){},
            //     onSuccess: function(){}
            // });

            init({ 
                user: User.fromAttributes(attributes),
                manifest: manifest
            });
        },
        onFailure: function(err) {
            if (Allowance.exceeded()) {
                err = "allowance exceeded";
            }
            switch (String(err)) {
                case "no session" :
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

                default : 
                    console.log("Unknown get session error", err);
            }
        }
    });
};
