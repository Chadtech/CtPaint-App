module Data.Window exposing (Window(..), toUrl)


type Window
    = Settings
    | Home
    | Register
    | ForgotPassword
    | AllowanceExceeded


toUrl : String -> Window -> String
toUrl mountPath window =
    mountPath ++ toUrlHelper window


toUrlHelper : Window -> String
toUrlHelper window =
    case window of
        Settings ->
            "/settings"

        Home ->
            "/"

        Register ->
            "/register"

        ForgotPassword ->
            "/forgotpassword"

        AllowanceExceeded ->
            "/allowance-exceeded"
