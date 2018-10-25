module Color.Picker.Track exposing (track)

import Color.Picker.Data.Gradient as Gradient
    exposing
        ( Gradient
        )
import Color.Picker.Msg
    exposing
        ( Msg(..)
        , directionToString
        )
import Data.Tracking as Tracking
import Json.Encode as E
import Util exposing (def)


track : Msg -> Tracking.Event
track msg =
    case msg of
        InputFocused ->
            "input-focused"
                |> Tracking.noProps

        InputBlurred ->
            "input-blurred"
                |> Tracking.noProps

        StealSubmit ->
            Tracking.none

        HexFieldUpdated _ ->
            Tracking.none

        MouseDownOnPointer gradient ->
            [ gradientField gradient ]
                |> Tracking.withProps
                    "mouse-down-on-pointer"

        GradientMouseDown gradient _ ->
            [ gradientField gradient ]
                |> Tracking.withProps
                    "gradient-mouse-down"

        MouseMoveInGradient _ _ ->
            Tracking.none

        FieldUpdated _ _ ->
            Tracking.none

        ArrowClicked gradient direction ->
            [ gradientField gradient
            , direction
                |> directionToString
                |> E.string
                |> def "direction"
            ]
                |> Tracking.withProps
                    "arrow-clicked"

        HeaderMouseDown _ ->
            "header-mouse-down"
                |> Tracking.noProps

        XButtonMouseDown ->
            Tracking.none

        XButtonMouseUp ->
            "x-button-mouse-up"
                |> Tracking.noProps

        ClientMouseUp ->
            Tracking.none

        ClientMouseMove _ ->
            Tracking.none


gradientField : Gradient -> ( String, E.Value )
gradientField gradient =
    gradient
        |> Gradient.toString
        |> E.string
        |> def "gradient"
