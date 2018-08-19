port module Subscriptions exposing (subscriptions)

import AnimationFrame
import Canvas exposing (DrawOp(Batch))
import Color.Msg as Color
import Color.Picker.Subscriptions as Picker
import Data.Keys as Keys
import Json.Decode as Decode exposing (Value)
import Menu.Subscriptions as Menu
import Minimap.Subscriptions as Minimap
import Model exposing (Model)
import Msg exposing (Msg(..))
import Ports
import Tool.Subscriptions as Tool
import Window


port keyEvent : (Value -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    [ Window.resizes WindowSizeReceived
    , animationFrame model
    , model.color.picker
        |> Picker.subscriptions
        |> Sub.map (ColorMsg << Color.PickerMsg)
    , model.minimap
        |> Minimap.subscriptions
        |> Sub.map MinimapMsg
    , keyEvent keyboardMsg
    , Sub.map MenuMsg (Menu.subscriptions model.menu)
    , Ports.fromJs (Msg.decode (Model.usersBrowser model))
    , Sub.map ToolMsg (Tool.subscriptions model)
    ]
        |> Sub.batch


animationFrame : Model -> Sub Msg
animationFrame model =
    if model.draws.pending == Canvas.Batch [] then
        Sub.none
    else
        AnimationFrame.diffs Tick


keyboardMsg : Value -> Msg
keyboardMsg =
    KeyboardEvent << Decode.decodeValue Keys.eventDecoder
