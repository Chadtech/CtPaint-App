port module Subscriptions exposing (subscriptions)

import AnimationFrame
import Canvas exposing (DrawOp(Batch))
import Color.Msg as Color
import Color.Picker.Subscriptions as Picker
import Data.Keys as Keys
import Data.Minimap exposing (State(..))
import Init
import Json.Decode as Decode exposing (Value)
import Menu.Subscriptions as Menu
import Minimap
import Model exposing (Model)
import Msg exposing (Msg(..))
import Ports
import Tool.Subscriptions as Tool
import Window


port keyEvent : (Value -> msg) -> Sub msg


subscriptions : Result Init.Error Model -> Sub Msg
subscriptions result =
    case result of
        Ok model ->
            fromModel model

        Err _ ->
            Sub.none


fromModel : Model -> Sub Msg
fromModel model =
    [ Window.resizes WindowSizeReceived
    , animationFrame model
    , model.color.picker
        |> Picker.subscriptions
        |> Sub.map (ColorMsg << Color.PickerMsg)
    , minimap model.minimap
    , keyEvent keyboardMsg
    , Sub.map MenuMsg (Menu.subscriptions model.menu)
    , Ports.fromJs (Msg.decode model.taco.config.browser)
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



-- MINIMAP --


minimap : Data.Minimap.State -> Sub Msg
minimap state =
    case state of
        Opened model ->
            Minimap.subscriptions model
                |> Sub.map MinimapMsg

        _ ->
            Sub.none
