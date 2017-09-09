module Main.Subscriptions exposing (subscriptions)

import AnimationFrame
import ColorPicker.Mouse as ColorPicker
import Keyboard.Subscriptions as Keyboard
import Keyboard.Types as Keyboard
import Main.Message exposing (Message(..))
import Main.Model exposing (Model)
import Main.Ports as Ports
import Menu.Download.Mouse as Download
import Menu.Import.Mouse as Import
import Menu.Types exposing (Menu(..))
import Minimap.Mouse as Minimap
import Mouse
import Taskbar.Util as Taskbar
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


subscriptions : Model -> Sub Message
subscriptions model =
    [ Window.resizes GetWindowSize
    , AnimationFrame.diffs Tick
    , Sub.map
        ColorPickerMessage
        (ColorPicker.subscriptions model.colorPicker)
    , Sub.map
        MinimapMessage
        (Minimap.subscriptions model.minimap)
    , listenForKeyCmds model keyboardUps
    , listenForKeyCmds model keyboardDowns
    , Sub.batch (toolSubs model)
    , menu model
    , Ports.windowFocus HandleWindowFocus
    ]
        |> maybeCons (Maybe.map Mouse.moves model.subMouseMove)
        |> Sub.batch



-- MENU --


menu : Model -> Sub Message
menu model =
    case model.menu of
        None ->
            Sub.none

        Download _ ->
            Sub.map
                Taskbar.download
                Download.subscriptions

        Import _ ->
            Sub.map
                Taskbar.import_
                Import.subscriptions

        _ ->
            Sub.none



-- SUBS --


toolSubs : Model -> List (Sub Message)
toolSubs { tool } =
    case tool of
        Hand _ ->
            List.map (Sub.map HandMessage) Hand.subs

        Sample ->
            List.map (Sub.map SampleMessage) Sample.subs

        Fill ->
            List.map (Sub.map FillMessage) Fill.subs

        Pencil _ ->
            List.map (Sub.map PencilMessage) Pencil.subs

        Line _ ->
            List.map (Sub.map LineMessage) Line.subs

        Rectangle _ ->
            List.map (Sub.map RectangleMessage) Rectangle.subs

        RectangleFilled _ ->
            List.map
                (Sub.map RectangleFilledMessage)
                RectangleFilled.subs

        Select _ ->
            List.map (Sub.map SelectMessage) Select.subs

        ZoomIn ->
            List.map (Sub.map ZoomInMessage) ZoomIn.subs

        ZoomOut ->
            List.map (Sub.map ZoomOutMessage) ZoomOut.subs


keyboardUps : Sub Message
keyboardUps =
    Keyboard.keyUp
        (KeyboardMessage << Keyboard.KeyEvent << Keyboard.Up)


keyboardDowns : Sub Message
keyboardDowns =
    Keyboard.keyDown
        (KeyboardMessage << Keyboard.KeyEvent << Keyboard.Down)



-- HELPERS --


listenForKeyCmds : Model -> Sub Message -> Sub Message
listenForKeyCmds { menu, colorPicker } sub =
    case ( menu, colorPicker.focusedOn ) of
        ( None, False ) ->
            sub

        _ ->
            Sub.none
