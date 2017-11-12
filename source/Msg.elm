module Msg exposing (Msg(..), decode)

import ColorPicker
import Data.Keys exposing (KeyEvent)
import Json.Decode as Decode exposing (Decoder, Value)
import Menu
import Minimap
import MouseEvents exposing (MouseEvent)
import Palette
import Taskbar
import Time exposing (Time)
import Tool exposing (Tool)
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
    | KeyboardEvent (Result String KeyEvent)
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
        |> Decode.map (toMsg json)


toMsg : Value -> String -> Msg
toMsg json type_ =
    case type_ of
        "login failed" ->
            json
                |> decodePayload Decode.string
                |> Result.withDefault "couldnt decode error"
                |> Menu.loginFailed
                |> MenuMsg

        _ ->
            MsgDecodeFailed UnrecognizedMsgType


decodePayload : Decoder a -> Value -> Result String a
decodePayload decoder =
    Decode.decodeValue (Decode.field "payload" decoder)
