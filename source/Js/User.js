var Allowance = require("./Allowance");

function fromAttributes(attributes) {
    var payload = {};

    for (var i = 0; i < attributes.length; i++) {
        payload[attributes[i].getName()] = attributes[i].getValue();
    }

    return payload;
}

function logout(Client, toElm) {
    function succeed() {
        toElm("logout succeeded", null);
    }
    Client.logout({
        onSuccess: succeed,
        onFailure: function(err) {
            switch (err) {
                case "user was not signed in":
                    succeed();
                    break;

                default:
                    toElm("logout failed", err);
                    break;
            }
        }
    });
}

function login(Client, toElm, payload) {
    Client.login(payload, {
        onSuccess: function(user) {
            user.getUserAttributes(function(err, attrs) {
                if (err) {
                    toElm("login failed", String(err));
                } else {
                    toElm("login succeeded", fromAttributes(attrs));
                }
            });
        },
        onFailure: function(err) {
            toElm("login failed", String(err));
        }
    });
}

function get(Client, init) {
    Client.getSession({
        onSuccess: function(attrs) {
            init(fromAttributes(attrs));
        },
        onFailure: function(err) {
            if (Allowance.exceeded()) {
                err = "allowance exceeded";
            }
            switch (String(err)) {
                case "no session":
                    init(null);
                    break;

                case "NetworkingError: Network Failure":
                    init("offline");
                    break;

                case "allowance exceeded":
                    init("allowance exceeded");
                    break;

                default:
                    init("Unknown get session error");
            }
        }
    });
}

module.exports = function(Client, toElm) {
    return {
        fromAttributes: fromAttributes,
        logout: function() {
            logout(Client, toElm);
        },
        login: function(payload) {
            login(Client, toElm, payload);
        },
        get: function(init) {
            get(Client, init);
        }
    };
};
