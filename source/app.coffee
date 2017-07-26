_ = require "lodash"
AmazonCognitoIdentity = require 'amazon-cognito-identity-js'
CognitoUserPool = AmazonCognitoIdentity.CognitoUserPool

init = (app) ->
    app.ports.register.subscribe (register app, userPool)
    app.ports.verify.subscribe (verify app, userPool)
    app.ports.login.subscribe (login app, userPool)
            
poolData =
    UserPoolId: "us-east-2_xc2oQp2ju"
    ClientId: "7r81o7o9pnar49lrh54mhv0u5s"

userPool = new CognitoUserPool poolData

register = require "./Aws/register"
verify = require "./Aws/verify"
login = require "./Aws/login"


user = userPool.getCurrentUser()

attributesWeWant = [ 
    "nickname"
    "email"
]

makeFlags = (obj, attr) ->
    if attr.Name in attributesWeWant
        obj[ attr.Name ] = attr.Value
    obj


if user isnt null 
    user.getSession (err, session) ->
        if err
            console.log err
            return 

        user.getUserAttributes (err, attributes) ->
            flags = {}

            if err
                console.log "Error getting attributes : ", err
                return null
            else
                flags = _.reduce attributes, makeFlags, flags

            init (Elm.Main.fullscreen flags)
else
    init (Elm.Main.fullscreen null)





