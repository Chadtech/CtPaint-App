port module Subscriptions exposing (subscriptions)

import AnimationFrame
import ColorPicker
import Data.Keys exposing (decodeKeyEvent)
import Data.Menu
import Json.Decode exposing (Value)
import Menu
import Minimap
import Msg exposing (Msg(..))
import Ports
import Tool
import Types
    exposing
        ( MinimapState(..)
        , Model
        )
import Window


port keyEvent : (Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    [ Window.resizes WindowSizeReceived
    , AnimationFrame.diffs Tick
    , Sub.map
        ColorPickerMsg
        (ColorPicker.subscriptions model.colorPicker)
    , minimap model.minimap
    , keyEvent (KeyboardEvent << decodeKeyEvent)
    , Sub.map ToolMsg (Tool.subscriptions model.tool)
    , menu model.menu
    , Ports.fromJs Msg.decode
    ]
        |> Sub.batch



-- MINIMAP --


minimap : MinimapState -> Sub Msg
minimap state =
    case state of
        Minimap model ->
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
