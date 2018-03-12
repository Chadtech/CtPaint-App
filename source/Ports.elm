port module Ports
    exposing
        ( JsMsg(..)
        , SavePayload
        , fromJs
        , returnFocus
        , send
        , stealFocus
        , track
        )

import Array exposing (Array)
import Canvas exposing (Canvas, Size)
import Color exposing (Color)
import Data.Color as Color exposing (Swatches)
import Id exposing (Id, Origin(Local, Remote))
import Json.Encode as Encode exposing (Value)
import Tracking
import Tuple.Infix exposing ((:=))
import Util


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
    | ReportBug String
    | LoadDrawing Id
    | Track Tracking.Payload


type alias SavePayload =
    { canvas : Canvas
    , swatches : Swatches
    , palette : Array Color
    , name : String
    , nameIsGenerated : Bool
    , email : String
    , id : Origin
    }


returnFocus : Cmd msg
returnFocus =
    send ReturnFocus


stealFocus : Cmd msg
stealFocus =
    send StealFocus


toCmd : String -> Value -> Cmd msg
toCmd type_ payload =
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
            toCmd "stealFocus" Encode.null

        ReturnFocus ->
            toCmd "returnFocus" Encode.null

        Save { swatches, palette, canvas, name, nameIsGenerated, id, email } ->
            [ "canvas" := Color.encodeCanvas canvas
            , "palette" := Color.encodePalette palette
            , "swatches" := Color.encodeSwatches swatches
            , "name" := Encode.string name
            , "nameIsGenerated" := Encode.bool nameIsGenerated
            , "email" := Encode.string email
            , "id" := Util.encodeOrigin id
            ]
                |> Encode.object
                |> toCmd "save"

        Download fn ->
            toCmd "download" (Encode.string fn)

        AttemptLogin email password ->
            [ "email" := Encode.string email
            , "password" := Encode.string password
            ]
                |> Encode.object
                |> toCmd "attemptLogin"

        Logout ->
            toCmd "logout" Encode.null

        OpenNewWindow url ->
            url
                |> Encode.string
                |> toCmd "openNewWindow"

        RedirectPageTo url ->
            url
                |> Encode.string
                |> toCmd "redirectPageTo"

        OpenUpFileUpload ->
            toCmd "openUpFileUpload" Encode.null

        ReadFile ->
            toCmd "readFile" Encode.null

        ReportBug bug ->
            toCmd "bugReport" (Encode.string bug)

        LoadDrawing id ->
            toCmd "loadDrawing" (Id.encode id)

        Track payload ->
            toCmd "track" (Tracking.encode payload)


port toJs : Value -> Cmd msg


port fromJs : (Value -> msg) -> Sub msg
