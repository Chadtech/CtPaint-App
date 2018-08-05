module Data.Window
    exposing
        ( Window(..)
        , open
        , toString
        , toUrl
        )

import Id exposing (Id)
import Ports exposing (JsMsg(OpenNewWindow))


-- TYPES --


type Window
    = Settings
    | Home
    | Register
    | ForgotPassword
    | AllowanceExceeded
    | Drawing Id



-- HELPERS --


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


toString : Window -> String
toString window =
    case window of
        Drawing _ ->
            "drawing"

        _ ->
            window
                |> Basics.toString
                |> String.toLower


open : String -> Window -> Cmd msg
open mountPath window =
    window
        |> toUrl mountPath
        |> OpenNewWindow
        |> Ports.send
