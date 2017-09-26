port module Subscriptions exposing (subscriptions)

import AnimationFrame
import ColorPicker
import Json.Decode exposing (Value)
import Menu
import Minimap
import Tool
import Types exposing (Direction(..), Model, Msg(..))
import Window


port keyEvent : (Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    [ Window.resizes GetWindowSize
    , AnimationFrame.diffs Tick
    , Sub.map
        ColorPickerMsg
        (ColorPicker.subscriptions model.colorPicker)
    , Sub.map
        MinimapMsg
        (Minimap.subscriptions model.minimap)
    , keyEvent KeyboardEvent
    , Sub.map ToolMsg (Tool.subscriptions model.tool)
    , menu model.menu
    ]
        |> Sub.batch



-- MENU --


menu : Maybe Menu.Model -> Sub Msg
menu maybeMenu =
    case maybeMenu of
        Just _ ->
            Sub.map MenuMsg Menu.subscriptions

        Nothing ->
            Sub.none
