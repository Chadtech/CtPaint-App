module Msg exposing (Msg(..), decode)

import ColorPicker
import Data.Keys as Key
import Data.Menu as Menu
import Data.Minimap as Minimap
import Data.User as User exposing (User)
import Json.Decode as Decode exposing (Decoder, Value)
import MouseEvents exposing (MouseEvent)
import Palette
import Taskbar
import Time exposing (Time)
import Tool
import Toolbar
import Window exposing (Size)


type Msg
    = WindowSizeReceived Size
    | ToolbarMsg Toolbar.Msg
    | TaskbarMsg Taskbar.Msg
    | PaletteMsg Palette.Msg
    | ToolMsg Tool.Msg
    | MenuMsg Menu.Msg
    | Tick Time
    | ColorPickerMsg ColorPicker.Msg
    | MinimapMsg Minimap.Msg
    | ScreenMouseMove MouseEvent
    | ScreenMouseExit
    | KeyboardEvent (Result String Key.Event)
    | LogoutSucceeded
    | LogoutFailed String
    | MsgDecodeFailed DecodeProblem


type DecodeProblem
    = Other String
    | UnrecognizedMsgType



-- DECODER --


decode : Value -> Msg
decode json =
    case Decode.decodeValue (decoder json) json of
        Ok msg ->
            msg

        Err err ->
            MsgDecodeFailed (Other err)


decoder : Value -> Decoder Msg
decoder json =
    Decode.field "type" Decode.string
        |> Decode.andThen toMsg


toMsg : String -> Decoder Msg
toMsg type_ =
    case type_ of
        "login succeeded" ->
            payload User.decoder
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
