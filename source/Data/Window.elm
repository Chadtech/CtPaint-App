module Data.Window
    exposing
        ( Window(..)
        , toUrl
        )

import Id exposing (Id)


type Window
    = Settings
    | Home
    | Register
    | ForgotPassword
    | AllowanceExceeded
    | Drawing Id


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
            mountPath ++ "/allowanceexceeded"

        Drawing id ->
            [ "https://s3.us-east-2.amazonaws.com/ctpaint-drawings-uploads"
            , Id.toString id
            ]
                |> String.join "/"
