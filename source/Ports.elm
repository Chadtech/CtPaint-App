port module Ports exposing (..)

import Canvas exposing (Canvas, Size)
import Data.Project as Project exposing (Project)
import Json.Encode as Encode exposing (Value)
import Json.Encode.Extra as Encode
import Tuple.Infix exposing ((:=))


type JsMsg
    = StealFocus
    | ReturnFocus
    | SaveLocally LocalSavePayload
    | SaveToAws
    | Download String
    | AttemptLogin String String
    | Logout


type alias LocalSavePayload =
    { canvas : Canvas
    , project : Maybe Project
    }


encodeCanvas : Canvas -> Value
encodeCanvas =
    Canvas.toDataUrl "image/png" 1 >> Encode.string


jsMsg : String -> Value -> Cmd msg
jsMsg type_ payload =
    [ "type" := Encode.string type_
    , "payload" := payload
    ]
        |> Encode.object
        |> toJs


send : JsMsg -> Cmd msg
send msg =
    case msg of
        StealFocus ->
            jsMsg "steal focus" Encode.null

        ReturnFocus ->
            jsMsg "return focus" Encode.null

        SaveLocally { canvas, project } ->
            let
                { width, height } =
                    Canvas.getSize canvas
            in
            [ "width" := Encode.int width
            , "height" := Encode.int height
            , "data" := encodeCanvas canvas
            , "project" := Encode.maybe Project.encode project
            ]
                |> Encode.object
                |> jsMsg "save locally"

        SaveToAws ->
            jsMsg "save to aws" Encode.null

        Download fn ->
            jsMsg "download" (Encode.string fn)

        AttemptLogin email password ->
            [ "email" := Encode.string email
            , "password" := Encode.string password
            ]
                |> Encode.object
                |> jsMsg "attempt login"

        Logout ->
            jsMsg "logout" Encode.null


port toJs : Value -> Cmd msg


port fromJs : (Value -> msg) -> Sub msg
