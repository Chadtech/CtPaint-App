module Subscriptions exposing (subscriptions)

import AnimationFrame
import ColorPicker.Mouse as ColorPicker
import Keyboard.Subscriptions as Keyboard
import Keyboard.Types
import Menu.Download.Mouse as Download
import Menu.Import.Mouse as Import
import Menu.MsgMap
import Menu.Scale.Mouse as Scale
import Menu.Types exposing (Menu(..))
import Minimap.Mouse as Minimap
import Model exposing (Model)
import Mouse
import Msg exposing (Msg(..))
import Ports as Ports
import Tool.Fill.Mouse as Fill
import Tool.Hand.Mouse as Hand
import Tool.Line.Mouse as Line
import Tool.Pencil.Mouse as Pencil
import Tool.Rectangle.Mouse as Rectangle
import Tool.RectangleFilled.Mouse as RectangleFilled
import Tool.Sample.Mouse as Sample
import Tool.Select.Mouse as Select
import Tool.Types exposing (Tool(..))
import Tool.ZoomIn.Mouse as ZoomIn
import Tool.ZoomOut.Mouse as ZoomOut
import Util exposing (maybeCons)
import Window


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
    , keyboardUps
    , keyboardDowns
    , Sub.batch (toolSubs model)
    , menu model
    , Ports.windowFocus HandleWindowFocus
    ]
        |> maybeCons (Maybe.map Mouse.moves model.subMouseMove)
        |> Sub.batch



-- MENU --


menu : Model -> Sub Msg
menu model =
    case model.menu of
        None ->
            Sub.none

        Download _ ->
            Sub.map
                Menu.MsgMap.download
                Download.subscriptions

        Import _ ->
            Sub.map
                Menu.MsgMap.import_
                Import.subscriptions

        Scale _ ->
            Sub.map
                Menu.MsgMap.scale
                Scale.subscriptions

        _ ->
            Sub.none



-- SUBS --


toolSubs : Model -> List (Sub Msg)
toolSubs { tool } =
    case tool of
        Hand _ ->
            List.map (Sub.map HandMsg) Hand.subs

        Sample ->
            List.map (Sub.map SampleMsg) Sample.subs

        Fill ->
            List.map (Sub.map FillMsg) Fill.subs

        Pencil _ ->
            List.map (Sub.map PencilMsg) Pencil.subs

        Line _ ->
            List.map (Sub.map LineMsg) Line.subs

        Rectangle _ ->
            List.map (Sub.map RectangleMsg) Rectangle.subs

        RectangleFilled _ ->
            List.map
                (Sub.map RectangleFilledMsg)
                RectangleFilled.subs

        Select _ ->
            List.map (Sub.map SelectMsg) Select.subs

        ZoomIn ->
            List.map (Sub.map ZoomInMsg) ZoomIn.subs

        ZoomOut ->
            List.map (Sub.map ZoomOutMsg) ZoomOut.subs



-- KEYBOARD --


keyboardUps : Sub Msg
keyboardUps =
    Keyboard.keyUp <|
        Keyboard.Types.Up
            >> Keyboard.Types.KeyEvent
            >> KeyboardMsg


keyboardDowns : Sub Msg
keyboardDowns =
    Keyboard.keyDown <|
        Keyboard.Types.Down
            >> Keyboard.Types.KeyEvent
            >> KeyboardMsg
