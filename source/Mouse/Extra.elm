module Mouse.Extra
    exposing
        ( Button(..)
        , onContextMenu
        , onMouseDown
        )

import DOM exposing (Rectangle)
import Html
import Html.Events exposing (defaultOptions, on)
import Json.Decode as Decode exposing (Decoder)
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
        (Decode.succeed msg)


onMouseDown : Bool -> (Button -> MouseEvent -> msg) -> Html.Attribute msg
onMouseDown isMac ctor =
    Decode.map2 ctor
        (buttonDecoder isMac)
        mouseEventDecoder
        |> on "mousedown"


buttonDecoder : Bool -> Decoder Button
buttonDecoder isMac =
    if isMac then
        Decode.field "ctrlKey" Decode.bool
            |> Decode.andThen fromCtrlDecoder
    else
        Decode.field "which" Decode.int
            |> Decode.andThen fromWhichDecoder


fromCtrlDecoder : Bool -> Decoder Button
fromCtrlDecoder ctrl =
    if ctrl then
        Decode.succeed Right
    else
        Decode.succeed Left


fromWhichDecoder : Int -> Decoder Button
fromWhichDecoder which =
    if which == 3 then
        Decode.succeed Right
    else
        Decode.succeed Left


mouseEventDecoder : Decode.Decoder MouseEvent
mouseEventDecoder =
    Decode.map3
        mouseEvent
        (Decode.field "clientX" Decode.int)
        (Decode.field "clientY" Decode.int)
        (Decode.field "target" DOM.boundingClientRect)


mouseEvent : Int -> Int -> Rectangle -> MouseEvent
mouseEvent clientX clientY target =
    { clientPos = Position clientX clientY
    , targetPos = Position (truncate target.left) (truncate target.top)
    }
