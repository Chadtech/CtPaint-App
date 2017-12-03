module Data.Window exposing (Window(..), toUrl)

import Data.Config exposing (Config)


type Window
    = Preferences
    | Home
    | Donate
    | Tutorial
    | Register


toUrl : Config -> Window -> String
toUrl { mountPath } window =
    case window of
        Preferences ->
            "https://www.twitter.com"

        Home ->
            "https://www.twitter.com"

        Register ->
            mountPath ++ "/register"

        _ ->
            "asd"
