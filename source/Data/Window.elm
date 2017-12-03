module Data.Window exposing (Window(..), toUrl)


type Window
    = Preferences
    | Home
    | Donate
    | Tutorial
    | Register


toUrl : Window -> String
toUrl window =
    case window of
        Preferences ->
            "https://www.twitter.com"

        Home ->
            "https://www.twitter.com"

        _ ->
            "asd"
