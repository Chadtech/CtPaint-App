module Data.Window exposing (Window(..), toUrl)

import Data.Config exposing (Config)


type Window
    = Settings
    | Home
    | Donate
    | Tutorial
    | Register


toUrl : Config -> Window -> String
toUrl { mountPath } window =
    case window of
        Settings ->
            mountPath ++ "/settings"

        Home ->
            mountPath ++ "/"

        Register ->
            mountPath ++ "/register"

        _ ->
            "asd"
