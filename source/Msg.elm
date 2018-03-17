module Msg exposing (Msg(..), decode)

import Canvas exposing (Canvas, Error)
import Data.Drawing as Drawing exposing (Drawing)
import Data.Keys as Key
import Data.Menu as Menu
import Data.Minimap as Minimap
import Data.Picker as Picker
import Data.User as User exposing (User)
import Json.Decode as Decode exposing (Decoder, Value)
import Keyboard.Extra.Browser exposing (Browser)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Palette
import Taskbar
import Time exposing (Time)
import Toolbar
import Window exposing (Size)


type Msg
    = WindowSizeReceived Size
    | ToolbarMsg Toolbar.Msg
    | TaskbarMsg Taskbar.Msg
    | PaletteMsg Palette.Msg
    | MenuMsg Menu.Msg
    | Tick Time
    | ColorPickerMsg Picker.Msg
    | MinimapMsg Minimap.Msg
    | ScreenMouseDown MouseEvent
    | ScreenMouseUp MouseEvent
    | ScreenMouseMove MouseEvent
    | ScreenMouseExit
    | KeyboardEvent (Result String Key.Event)
    | LogoutSucceeded
    | LogoutFailed String
    | ClientMouseMoved Position
    | ClientMouseUp Position
    | InitFromUrl (Result Error Canvas)
    | DrawingLoaded Drawing
    | DrawingDeblobed Drawing (Result Error Canvas)
    | MsgDecodeFailed DecodeProblem


type DecodeProblem
    = Other String
    | UnrecognizedMsgType String



-- DECODER --


decode : Browser -> Value -> Msg
decode browser json =
    case Decode.decodeValue (decoder browser) json of
        Ok msg ->
            msg

        Err err ->
            MsgDecodeFailed (Other err)


decoder : Browser -> Decoder Msg
decoder browser =
    Decode.field "type" Decode.string
        |> Decode.andThen (payload << toMsg browser)


toMsg : Browser -> String -> Decoder Msg
toMsg browser type_ =
    case type_ of
        "login succeeded" ->
            browser
                |> User.decoder
                |> Decode.map (Menu.loginSucceeded >> MenuMsg)

        "login failed" ->
            Decode.string
                |> Decode.map (Menu.loginFailed >> MenuMsg)

        "logout succeeded" ->
            Decode.succeed LogoutSucceeded

        "logout failed" ->
            Decode.string
                |> Decode.map LogoutFailed

        "file read" ->
            Decode.string
                |> Decode.map (Menu.fileRead >> MenuMsg)

        "file not image" ->
            Menu.fileNotImage
                |> MenuMsg
                |> Decode.succeed

        "drawing loaded" ->
            Drawing.decoder
                |> Decode.map DrawingLoaded

        "drawing update completed" ->
            [ Decode.string
                |> Decode.map
                    (Ok >> Menu.drawingUpdateCompleted)
            , "Result had no data"
                |> Err
                |> Menu.drawingUpdateCompleted
                |> Decode.null
            ]
                |> Decode.oneOf
                |> Decode.map MenuMsg

        "drawing create completed" ->
            [ Decode.string
                |> Decode.map
                    (Err >> Menu.drawingCreateCompleted)
            , { fromErr = Err >> Menu.drawingCreateCompleted
              , fromData = Ok >> Menu.drawingCreateCompleted
              , decoder = Drawing.decoder
              }
                |> recordingDecoder
            ]
                |> Decode.oneOf
                |> Decode.map MenuMsg

        _ ->
            type_
                |> UnrecognizedMsgType
                |> MsgDecodeFailed
                |> Decode.succeed


type alias RecordingConfig a msg =
    { fromErr : String -> msg
    , fromData : a -> msg
    , decoder : Decoder a
    }


recordingDecoder : RecordingConfig a msg -> Decoder msg
recordingDecoder config =
    Decode.value
        |> Decode.andThen
            (toResult config >> Decode.succeed)


toResult : RecordingConfig a msg -> Value -> msg
toResult { fromErr, fromData, decoder } json =
    case Decode.decodeValue decoder json of
        Ok data ->
            fromData data

        Err err ->
            fromErr err


payload : Decoder a -> Decoder a
payload =
    Decode.field "payload"
