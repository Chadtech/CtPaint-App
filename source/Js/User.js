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

module.exports = function(Client, toElm) {
    return {
        fromAttributes: fromAttributes,
        logout: function() {
            logout(Client, toElm);
        },
        login: function(payload) {
            login(Client, toElm, payload);
        }
    };
};
