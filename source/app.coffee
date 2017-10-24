_ = require "lodash"
AmazonCognitoIdentity = require 'amazon-cognito-identity-js'
CognitoUserPool = AmazonCognitoIdentity.CognitoUserPool


listenToKeyEvents = (keydown, keyup) ->
    window.addEventListener 'keydown', keydown
    window.addEventListener 'keyup', keyup


ignoreKeyEvents = (keydown, keyup) ->
    window.removeEventListener 'keydown', keydown
    window.removeEventListener 'keyup', keyup

window.onbeforeunload = (event) -> ""

init = (app) ->
    makeKeyHandler = (direction) ->
        (event) ->
            app.ports.keyEvent.send
                keyCode: event.keyCode
                shift: event.shiftKey
                meta: event.metaKey
                ctrl: event.ctrlKey
                direction: direction

            event.preventDefault()

    handleKeyDown = makeKeyHandler "down"
    handleKeyUp = makeKeyHandler "up"

    listenToKeyEvents handleKeyDown, handleKeyUp

    jsMsgHandler = (msg) ->
        switch msg.type
            when "save"
                localStorage.setItem "canvas", JSON.stringify msg.payload

            when "steal focus"
                ignoreKeyEvents handleKeyDown, handleKeyUp

            when "return focus"
                listenToKeyEvents handleKeyDown, handleKeyUp

            when "download"
                canvas = document.getElementById "main-canvas"
                png = canvas.toDataUrl()

                a = document.createElement "a"
                a.href = png
                a.download = msg.payload
                a.click()

    app.ports.toJs.subscribe jsMsgHandler

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


canvas = localStorage.getItem "canvas"

flags = {
    windowHeight: window.innerHeight,
    windowWidth: window.innerWidth,
    seed: Math.round (Math.random() * 999999999999)
    isMac: (window.navigator.userAgent.indexOf "Mac") isnt -1
    isChrome: (window.navigator.userAgent.indexOf "Chrome") isnt -1
    canvas: JSON.parse canvas
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

