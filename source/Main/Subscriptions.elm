module Main.Subscriptions exposing (subscriptions)

import Main.Model exposing (Model)
import Main.Message exposing (Message(..))
import Util exposing (maybeCons)
import Tool.Types exposing (Tool(..))
import Tool.Hand.Mouse as Hand
import Tool.Pencil.Mouse as Pencil
import Tool.Line.Mouse as Line
import Tool.ZoomIn.Mouse as ZoomIn
import Tool.ZoomOut.Mouse as ZoomOut
import Tool.Rectangle.Mouse as Rectangle
import Tool.RectangleFilled.Mouse as RectangleFilled
import Tool.Select.Mouse as Select
import Tool.Sample.Mouse as Sample
import Tool.Fill.Mouse as Fill
import ColorPicker.Mouse as ColorPicker
import Mouse
import Window
import AnimationFrame
import Keyboard
import Keyboard.Types as Keyboard


subscriptions : Model -> Sub Message
subscriptions model =
    [ Window.resizes GetWindowSize
    , AnimationFrame.diffs Tick
    , ColorPicker.subscriptions model.colorPicker
    , ifTheresAFocus model.textInputFocused keyboardUps
    , ifTheresAFocus model.textInputFocused keyboardDowns
    , Sub.batch (toolSubs model)
    ]
        |> maybeCons (Maybe.map Mouse.moves model.subMouseMove)
        |> Sub.batch



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
    Keyboard.ups
        (KeyboardMessage << Keyboard.KeyEvent << Keyboard.Up)


keyboardDowns : Sub Message
keyboardDowns =
    Keyboard.downs
        (KeyboardMessage << Keyboard.KeyEvent << Keyboard.Down)



-- HELPERS --


ifTheresAFocus : Bool -> Sub Message -> Sub Message
ifTheresAFocus isAFocus sub =
    if isAFocus then
        Sub.none
    else
        sub
