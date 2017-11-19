module Data.Window exposing (Window(..))


type Window
    = Preferences
    | Home
    | Donate
    | Tutorial


toUrl : Window -> String
toUrl window =
    case window of
        Preferences ->
            "https://www.twitter.com"

        Home ->
            "https://www.twitter.com"

        _ ->
            "asd"
