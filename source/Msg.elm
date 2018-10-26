module Msg exposing
    ( Msg(..)
    , decode
    , decodeProblemToString
    , loadCmd
    )

import Canvas exposing (Canvas, Error)
import Color.Msg as Color
import Data.Drawing as Drawing exposing (Drawing)
import Data.Keys as Key
import Data.User as User exposing (User)
import Json.Decode as D exposing (Decoder)
import Keyboard.Extra.Browser exposing (Browser)
import Menu.Msg as Menu
import Minimap.Msg as Minimap
import MouseEvents exposing (MouseEvent)
import Task
import Taskbar.Msg as Taskbar
import Time exposing (Time)
import Tool.Msg as Tool
import Toolbar
import Window exposing (Size)


type Msg
    = WindowSizeReceived Size
    | ToolbarMsg Toolbar.Msg
    | TaskbarMsg Taskbar.Msg
    | MenuMsg Menu.Msg
    | Tick Time
    | ColorMsg Color.Msg
    | ToolMsg Tool.Msg
    | MinimapMsg Minimap.Msg
    | WorkareaMouseMove MouseEvent
    | WorkareaContextMenu
    | WorkareaMouseExit
    | KeyboardEvent (Result String Key.Event)
    | LogoutSucceeded
    | LogoutFailed String
    | InitFromUrl (Result Error Canvas)
    | DrawingLoaded Drawing
    | DrawingDeblobed Drawing (Result Error Canvas)
    | GalleryScreenClicked
    | FileRead String
    | FileNotImage
    | MsgDecodeFailed DecodeProblem


type DecodeProblem
    = Other String
    | UnrecognizedMsgType String


decodeProblemToString : DecodeProblem -> String
decodeProblemToString decodeProblem =
    case decodeProblem of
        Other str ->
            "Other : " ++ str

        UnrecognizedMsgType type_ ->
            "unrecognized msg type : " ++ type_


loadCmd : String -> Cmd Msg
loadCmd url =
    url
        |> Canvas.loadImage
        |> Task.attempt
            (Menu.loadedCanvas >> MenuMsg)



-- DECODER --


decode : Browser -> D.Value -> Msg
decode browser json =
    case D.decodeValue (decoder browser) json of
        Ok msg ->
            msg

        Err err ->
            MsgDecodeFailed (Other err)


decoder : Browser -> Decoder Msg
decoder browser =
    D.field "type" D.string
        |> D.andThen (payload << toMsg browser)


toMsg : Browser -> String -> Decoder Msg
toMsg browser type_ =
    case type_ of
        "login succeeded" ->
            browser
                |> User.decoder
                |> D.map (Menu.loginSucceeded >> MenuMsg)

        "login failed" ->
            D.string
                |> D.map (Menu.loginFailed >> MenuMsg)

        "logout succeeded" ->
            D.succeed LogoutSucceeded

        "logout failed" ->
            D.string
                |> D.map LogoutFailed

        "file read" ->
            D.string
                |> D.map FileRead

        "file not image" ->
            FileNotImage
                |> D.succeed

        "drawing loaded" ->
            Drawing.decoder
                |> D.map DrawingLoaded

        "drawing update completed" ->
            [ D.string
                |> D.map
                    (Ok >> Menu.drawingUpdateCompleted)
            , "Result had no data"
                |> Err
                |> Menu.drawingUpdateCompleted
                |> D.null
            ]
                |> D.oneOf
                |> D.map MenuMsg

        "drawing create completed" ->
            [ D.string
                |> D.map
                    (Err >> Menu.drawingCreateCompleted)
            , { fromErr = Err >> Menu.drawingCreateCompleted
              , fromData = Ok >> Menu.drawingCreateCompleted
              , decoder = Drawing.decoder
              }
                |> recordingDecoder
            ]
                |> D.oneOf
                |> D.map MenuMsg

        _ ->
            type_
                |> UnrecognizedMsgType
                |> MsgDecodeFailed
                |> D.succeed


type alias RecordingConfig a msg =
    { fromErr : String -> msg
    , fromData : a -> msg
    , decoder : Decoder a
    }


recordingDecoder : RecordingConfig a msg -> Decoder msg
recordingDecoder config =
    D.value
        |> D.andThen
            (toResult config >> D.succeed)


toResult : RecordingConfig a msg -> D.Value -> msg
toResult { fromErr, fromData, decoder } json =
    case D.decodeValue decoder json of
        Ok data ->
            fromData data

        Err err ->
            fromErr err


payload : Decoder a -> Decoder a
payload =
    D.field "payload"
