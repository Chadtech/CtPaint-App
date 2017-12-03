module Data.Window exposing (Window(..), toUrl)


type Window
    = Settings
    | Home
    | Donate
    | Tutorial
    | Register
    | AllowanceExceeded


toUrl : String -> Window -> String
toUrl mountPath window =
    case window of
        Settings ->
            mountPath ++ "/settings"

        Home ->
            mountPath ++ "/"

        Register ->
            mountPath ++ "/register"

        AllowanceExceeded ->
            mountPath ++ "/allowance-exceeded"

        _ ->
            "asd"
