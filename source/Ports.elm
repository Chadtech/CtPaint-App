port module Ports
    exposing
        ( JsMsg(..)
        , fromJs
        , send
        , track
        )

import Array exposing (Array)
import Canvas exposing (Canvas, Size)
import Color exposing (Color)
import Data.Color as Color exposing (Swatches)
import Data.Project as Project exposing (Project)
import Json.Encode as Encode exposing (Value)
import Tracking
import Tuple.Infix exposing ((:=))


type JsMsg
    = StealFocus
    | ReturnFocus
    | Save SavePayload
    | Download String
    | AttemptLogin String String
    | Logout
    | OpenNewWindow String
    | RedirectPageTo String
    | OpenUpFileUpload
    | ReadFile
    | Track Tracking.Payload


type alias SavePayload =
    { canvas : Canvas
    , swatches : Swatches
    , palette : Array Color
    , project : Project
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


track : Tracking.Payload -> Cmd msg
track =
    Track >> send


send : JsMsg -> Cmd msg
send msg =
    case msg of
        StealFocus ->
            jsMsg "steal focus" Encode.null

        ReturnFocus ->
            jsMsg "return focus" Encode.null

        Save { swatches, palette, canvas, project } ->
            [ "data" := encodeCanvas canvas
            , "project" := Project.encode project
            , "swatches" := Color.encodeSwatches swatches
            , "palette" := Color.encodePalette palette
            ]
                |> Encode.object
                |> jsMsg "save"

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

        OpenNewWindow url ->
            url
                |> Encode.string
                |> jsMsg "open new window"

        RedirectPageTo url ->
            url
                |> Encode.string
                |> jsMsg "redirect page to"

        OpenUpFileUpload ->
            jsMsg "open up file upload" Encode.null

        ReadFile ->
            jsMsg "read file" Encode.null

        Track payload ->
            jsMsg "track" (Tracking.encode payload)


port toJs : Value -> Cmd msg


port fromJs : (Value -> msg) -> Sub msg
