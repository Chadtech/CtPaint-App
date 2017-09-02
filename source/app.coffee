_ = require "lodash"
AmazonCognitoIdentity = require 'amazon-cognito-identity-js'
CognitoUserPool = AmazonCognitoIdentity.CognitoUserPool

init = (app) ->
    app.ports.download.subscribe (fn) ->
        canvas = document.getElementById "main-canvas"
        png = canvas.toDataURL()

        a = document.createElement "a"
        a.href = png
        a.download = fn + ".png"
        a.click()
    0

poolData =
    UserPoolId: "us-east-2_xc2oQp2ju"
    ClientId: "7r81o7o9pnar49lrh54mhv0u5s"

userPool = new CognitoUserPool poolData
user = userPool.getCurrentUser()


attributesWeWant =  [ 
    "nickname"
    "email"
]

makeFlags = (obj, attr) ->
    if attr.Name in attributesWeWant
        obj[ attr.Name ] = attr.Value
    obj


flags = {
    windowHeight: window.innerHeight,
    windowWidth: window.innerWidth,
    seed: Math.round (Math.random() * 999999999999)
}

if user isnt null 
    user.getSession (err, session) ->
        if err
            init (Elm.Main.fullscreen null)

            console.log err
            return 

        user.getUserAttributes (err, attributes) ->
            if err
                console.log "Error getting attributes : ", err
                return null
            else
                flags = _.reduce attributes, makeFlags, flags

            init (Elm.Main.fullscreen flags)
else
    init (Elm.Main.fullscreen flags)
