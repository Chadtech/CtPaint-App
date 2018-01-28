module Msg exposing (Msg(..), decode)

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
    | MsgDecodeFailed DecodeProblem


type DecodeProblem
    = Other String
    | UnrecognizedMsgType



-- DECODER --


decode : Browser -> Value -> Msg
decode browser json =
    case Decode.decodeValue (decoder browser json) json of
        Ok msg ->
            msg

        Err err ->
            MsgDecodeFailed (Other err)


decoder : Browser -> Value -> Decoder Msg
decoder browser json =
    Decode.field "type" Decode.string
        |> Decode.andThen (toMsg browser)


toMsg : Browser -> String -> Decoder Msg
toMsg browser type_ =
    case type_ of
        "login succeeded" ->
            browser
                |> User.decoder
                |> payload
                |> Decode.map (Menu.loginSucceeded >> MenuMsg)

        "login failed" ->
            payload Decode.string
                |> Decode.map (Menu.loginFailed >> MenuMsg)

        "logout succeeded" ->
            Decode.succeed LogoutSucceeded

        "logout failed" ->
            payload Decode.string
                |> Decode.map LogoutFailed

        "file read" ->
            payload Decode.string
                |> Decode.map (Menu.fileRead >> MenuMsg)

        "file not image" ->
            MenuMsg Menu.fileNotImage
                |> Decode.succeed

        _ ->
            MsgDecodeFailed UnrecognizedMsgType
                |> Decode.succeed


payload : Decoder a -> Decoder a
payload =
    Decode.field "payload"
