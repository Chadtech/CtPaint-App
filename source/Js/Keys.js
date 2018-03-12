module.exports = function(app) {
    window.onbeforeunload = function(event) {
        return "";
    };

    var handleKeyDown = makeKeyHandler(app, "down");
    var handleKeyUp = makeKeyHandler(app, "up");
    return {
        listenToEvents: function() {
            window.addEventListener("keydown", handleKeyDown);
            window.addEventListener("keyup", handleKeyUp);
        },
        ignoreEvents: function() {
            window.removeEventListener("keydown", handleKeyDown);
            window.removeEventListener("keyup", handleKeyUp);
        }
    };
};

function makeKeyHandler(app, direction) {
    return function(event) {
        app.elm.ports.keyEvent.send({
            keyCode: event.keyCode,
            shift: event.shiftKey,
            meta: event.metaKey,
            ctrl: event.ctrlKey,
            direction: direction
        });

        event.preventDefault();
    };
}
