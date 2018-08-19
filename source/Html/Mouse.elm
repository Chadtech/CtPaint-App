module Html.Mouse
    exposing
        ( Button(..)
        , onContextMenu
        , onMouseDown
        )

import DOM exposing (Rectangle)
import Html
import Html.Events exposing (defaultOptions, on)
import Json.Decode as JD exposing (Decoder)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)


type Button
    = Left
    | Right


onContextMenu : msg -> Html.Attribute msg
onContextMenu msg =
    Html.Events.onWithOptions
        "contextmenu"
        { stopPropagation = False
        , preventDefault = True
        }
        (JD.succeed msg)


onMouseDown : Bool -> (Button -> MouseEvent -> msg) -> Html.Attribute msg
onMouseDown isMac ctor =
    JD.map2 ctor
        (buttonDecoder isMac)
        mouseEventDecoder
        |> on "mousedown"


buttonDecoder : Bool -> Decoder Button
buttonDecoder isMac =
    if isMac then
        JD.field "ctrlKey" JD.bool
            |> JD.andThen fromCtrlDecoder
    else
        JD.field "which" JD.int
            |> JD.andThen fromWhichDecoder


fromCtrlDecoder : Bool -> Decoder Button
fromCtrlDecoder ctrl =
    if ctrl then
        JD.succeed Right
    else
        JD.succeed Left


fromWhichDecoder : Int -> Decoder Button
fromWhichDecoder which =
    if which == 3 then
        JD.succeed Right
    else
        JD.succeed Left


mouseEventDecoder : JD.Decoder MouseEvent
mouseEventDecoder =
    JD.map3
        mouseEvent
        (JD.field "clientX" JD.int)
        (JD.field "clientY" JD.int)
        (JD.field "target" DOM.boundingClientRect)


mouseEvent : Int -> Int -> Rectangle -> MouseEvent
mouseEvent clientX clientY target =
    { clientPos = Position clientX clientY
    , targetPos = Position (truncate target.left) (truncate target.top)
    }
