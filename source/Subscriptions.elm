port module Subscriptions exposing (subscriptions)

import AnimationFrame
import Canvas exposing (DrawOp(Batch))
import ColorPicker
import Data.Keys as Keys
import Data.Menu
import Data.Minimap exposing (State(..))
import Init
import Json.Decode as Decode exposing (Value)
import Menu
import Minimap
import Model exposing (Model)
import Mouse
import Msg exposing (Msg(..))
import Ports
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
        |> ColorPicker.subscriptions
        |> Sub.map ColorPickerMsg
    , minimap model.minimap
    , keyEvent keyboardMsg
    , menu model.menu
    , Ports.fromJs (Msg.decode model.config.browser)
    , Mouse.moves ClientMouseMoved
    , Mouse.ups ClientMouseUp
    ]
        |> Sub.batch


animationFrame : Model -> Sub Msg
animationFrame model =
    if model.pendingDraw == Canvas.Batch [] then
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



-- MENU --


menu : Maybe Data.Menu.Model -> Sub Msg
menu maybeMenu =
    case maybeMenu of
        Just _ ->
            Sub.map MenuMsg Menu.subscriptions

        Nothing ->
            Sub.none
