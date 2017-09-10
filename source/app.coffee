_ = require "lodash"
AmazonCognitoIdentity = require 'amazon-cognito-identity-js'
CognitoUserPool = AmazonCognitoIdentity.CognitoUserPool


listenToKeyEvents = (app, keydown, keyup) ->
    window.addEventListener 'keydown', keydown
    window.addEventListener 'keyup', keyup


ignoreKeyEvents = (app, keydown, keyup) ->
    window.removeEventListener 'keydown', keydown
    window.removeEventListener 'keyup', keyup


init = (app) ->
    app.ports.download.subscribe (fn) ->
        canvas = document.getElementById "main-canvas"
        png = canvas.toDataURL()

        a = document.createElement "a"
        a.href = png
        a.download = fn
        a.click()

    window.addEventListener 'focus', ->
        app.ports.windowFocus.send true

    window.addEventListener 'blur', ->
        app.ports.windowFocus.send false

    keyDownListener = (event) ->
        app.ports.keyDown.send event.keyCode
        event.preventDefault()

    keyUpListener = (event) ->
        app.ports.keyUp.send event.keyCode
        event.preventDefault()

    listenToKeyEvents app, keyDownListener, keyUpListener

    app.ports.stealFocus.subscribe ->
        ignoreKeyEvents app, keyDownListener, keyUpListener

    app.ports.returnFocus.subscribe ->
        listenToKeyEvents app, keyDownListener, keyUpListener

    app



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
    isMac: (window.navigator.userAgent.indexOf "Mac") isnt -1
    isChrome: (window.navigator.userAgent.indexOf "Chrome") isnt -1
}


if user isnt null 
    user.getSession (err, session) ->
        if err
            init (Elm.Main.fullscreen flags)

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

