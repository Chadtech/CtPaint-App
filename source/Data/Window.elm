module Data.Window exposing (Window(..), toUrl)


type Window
    = Settings
    | Home
    | Register
    | ForgotPassword
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

        ForgotPassword ->
            mountPath ++ "/forgotpassword"

        AllowanceExceeded ->
            mountPath ++ "/allowance-exceeded"
