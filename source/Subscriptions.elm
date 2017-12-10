port module Subscriptions exposing (subscriptions)

import AnimationFrame
import ColorPicker
import Data.Keys as Keys
import Data.Menu
import Data.Minimap exposing (State(..))
import Json.Decode as Decode exposing (Value)
import Menu
import Minimap
import Model exposing (Model)
import Msg exposing (Msg(..))
import Ports
import Tool
import Window


port keyEvent : (Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    [ Window.resizes WindowSizeReceived
    , AnimationFrame.diffs Tick
    , model.color.picker
        |> ColorPicker.subscriptions
        |> Sub.map ColorPickerMsg
    , minimap model.minimap
    , keyEvent (KeyboardEvent << Decode.decodeValue Keys.eventDecoder)
    , Sub.map ToolMsg (Tool.subscriptions model.tool)
    , menu model.menu
    , Ports.fromJs Msg.decode
    ]
        |> Sub.batch



-- MINIMAP --


minimap : Data.Minimap.State -> Sub Msg
minimap state =
    case state of
        Opened model ->
            Minimap.subscriptions model
                |> Sub.map MinimapMsg

        _ ->
            Sub.none



-- MENU --


menu : Maybe Data.Menu.Model -> Sub Msg
menu maybeMenu =
    case maybeMenu of
        Just _ ->
            Sub.map MenuMsg Menu.subscriptions

        Nothing ->
            Sub.none
