module ColorPicker.View exposing (view)

import Html exposing (Html, Attribute, div, p, text, a, input, form)
import Html.Attributes exposing (class, classList, style, spellcheck, value)
import Html.Events exposing (onClick, onSubmit, onMouseDown, onMouseUp, onFocus, onBlur, onInput)
import MouseEvents
import ColorPicker.Types exposing (..)
import ColorPicker.Util exposing (doesntHaveHue)
import Util exposing ((:=), left, top, toPosition)
import MouseEvents as Events
import Palette.Types as Palette
import Color exposing (Color)


view : Model -> Html Message
view model =
    div
        [ class "card color-picker"
        , style
            [ left model.position.x
            , top model.position.y
            ]
        ]
        [ div
            [ class "header"
            , Events.onMouseDown HeaderMouseDown
            ]
            [ p [] [ text "Color Editor" ]
            , a
                [ onClick Close ]
                [ text "x" ]
            ]
        , div
            [ class "body" ]
            (body model)
        ]



-- BODY --


body : Model -> List (Html Message)
body ({ colorHexField, color } as model) =
    [ div
        [ class "visualization"
        , style
            [ "background" := (Palette.toHex color) ]
        ]
        []
    , form
        [ onSubmit StealSubmit ]
        [ input
            [ spellcheck False
            , onFocus (HandleFocus True)
            , onBlur (HandleFocus False)
            , onInput UpdateColorHexField
            , value colorHexField
            ]
            []
        ]
    , slider "H" model.hueField Hue (hueGradient model)
    , slider "S" model.saturationField Saturation (saturationGradient model)
    , slider "L" model.lightnessField Lightness (lightnessGradient model)
    , slider "R" model.redField Red (redGradient model)
    , slider "G" model.greenField Green (greenGradient model)
    , slider "B" model.blueField Blue (blueGradient model)
    ]


slider : String -> String -> Gradient -> Html Message -> Html Message
slider label fieldContent gradient sliderGradient =
    div
        [ class "slider-container" ]
        [ p [] [ text label ]
        , sliderGradient
        , input
            [ onInput (FieldUpdate gradient)
            , value fieldContent
            , onFocus (HandleFocus True)
            , onBlur (HandleFocus False)
            ]
            []
        ]



-- SLIDERS --


redGradient : Model -> Html Message
redGradient { color, gradientClickedOn } =
    let
        { red, green, blue } =
            Color.toRgb color

        attributes : List (Attribute Message)
        attributes =
            let
                gradientField =
                    gradientStyle
                        [ Color.rgb 0 green blue
                        , Color.rgb 255 green blue
                        ]
            in
                addMouseMoveHandler
                    (gradientAttributes gradientField)
                    gradientClickedOn
                    Red
    in
        div
            attributes
            [ div
                [ classList
                    [ "pointer" := True
                    , "transparent" := (gradientClickedOn == (Just Red))
                    ]
                , style [ left (red - 2) ]
                , onMouseDown (MouseDownOnPointer Red)
                ]
                []
            ]


greenGradient : Model -> Html Message
greenGradient { color, gradientClickedOn } =
    let
        { red, green, blue } =
            Color.toRgb color

        attributes : List (Attribute Message)
        attributes =
            let
                gradientField =
                    gradientStyle
                        [ Color.rgb red 0 blue
                        , Color.rgb red 255 blue
                        ]
            in
                addMouseMoveHandler
                    (gradientAttributes gradientField)
                    gradientClickedOn
                    Green
    in
        div
            attributes
            [ div
                [ classList
                    [ "pointer" := True
                    , "transparent" := (gradientClickedOn == (Just Green))
                    ]
                , style [ left (green - 2) ]
                , onMouseDown (MouseDownOnPointer Green)
                ]
                []
            ]


blueGradient : Model -> Html Message
blueGradient { color, gradientClickedOn } =
    let
        { red, green, blue } =
            Color.toRgb color

        attributes : List (Attribute Message)
        attributes =
            let
                gradientField =
                    gradientStyle
                        [ Color.rgb red green 0
                        , Color.rgb red green 255
                        ]
            in
                addMouseMoveHandler
                    (gradientAttributes gradientField)
                    gradientClickedOn
                    Blue
    in
        div
            attributes
            [ div
                [ classList
                    [ "pointer" := True
                    , "transparent" := (gradientClickedOn == (Just Blue))
                    ]
                , style [ left (blue - 2) ]
                , onMouseDown (MouseDownOnPointer Blue)
                ]
                []
            ]


hueGradient : Model -> Html Message
hueGradient { color, gradientClickedOn } =
    let
        { red, green, blue } =
            Color.toRgb color

        { hue, saturation, lightness } =
            Color.toHsl color

        nanSafeGradient =
            if doesntHaveHue color then
                gradientStyle
                    [ Color.rgb red red red
                    , Color.rgb red red red
                    ]
            else
                let
                    atDegree : Float -> Color
                    atDegree degree =
                        Color.hsl
                            (degrees degree)
                            saturation
                            lightness
                in
                    [ 0, 60, 120, 180, 240, 300, 360 ]
                        |> List.map atDegree
                        |> gradientStyle

        attributes : List (Attribute Message)
        attributes =
            addMouseMoveHandler
                (gradientAttributes nanSafeGradient)
                gradientClickedOn
                Hue
    in
        div
            attributes
            [ div
                [ classList
                    [ "pointer" := True
                    , "transparent" := (gradientClickedOn == (Just Hue))
                    ]
                , style
                    [ left (floor ((hue / (2 * pi)) * 255)) ]
                , onMouseDown (MouseDownOnPointer Hue)
                ]
                []
            ]


saturationGradient : Model -> Html Message
saturationGradient { color, gradientClickedOn } =
    let
        { hue, saturation, lightness } =
            Color.toHsl color

        nanSafeGradient : ( String, String )
        nanSafeGradient =
            if doesntHaveHue color then
                let
                    { red } =
                        Color.toRgb color
                in
                    gradientStyle
                        [ Color.rgb red red red
                        , Color.rgb red red red
                        ]
            else
                gradientStyle
                    [ Color.hsl hue 0 lightness
                    , Color.hsl hue 1 lightness
                    ]

        attributes : List (Attribute Message)
        attributes =
            addMouseMoveHandler
                (gradientAttributes nanSafeGradient)
                gradientClickedOn
                Saturation
    in
        div
            attributes
            [ div
                [ classList
                    [ "pointer" := True
                    , "transparent" := (gradientClickedOn == (Just Saturation))
                    ]
                , style
                    [ left (floor (saturation * 255) - 2) ]
                , onMouseDown (MouseDownOnPointer Saturation)
                ]
                []
            ]


lightnessGradient : Model -> Html Message
lightnessGradient { color, gradientClickedOn } =
    let
        { hue, saturation, lightness } =
            Color.toHsl color

        nanSafeGradient : ( String, String )
        nanSafeGradient =
            if doesntHaveHue color then
                gradientStyle
                    [ Color.rgb 0 0 0
                    , Color.rgb 255 255 255
                    ]
            else
                gradientStyle
                    [ Color.hsl hue saturation 0
                    , Color.hsl hue saturation 0.5
                    , Color.hsl hue saturation 1
                    ]

        attributes : List (Attribute Message)
        attributes =
            addMouseMoveHandler
                (gradientAttributes nanSafeGradient)
                gradientClickedOn
                Lightness
    in
        div
            attributes
            [ div
                [ classList
                    [ "pointer" := True
                    , "transparent" := (gradientClickedOn == (Just Lightness))
                    ]
                , style
                    [ left (floor (lightness * 255) - 2) ]
                , onMouseDown (MouseDownOnPointer Lightness)
                ]
                []
            ]



-- INTERNAL HELPERS --


gradientAttributes : ( String, String ) -> List (Attribute Message)
gradientAttributes gradientStyle_ =
    [ class "gradient"
    , style [ gradientStyle_ ]
    , onMouseUp SetNoGradientClickedOn
    ]


addMouseMoveHandler : List (Attribute Message) -> Maybe Gradient -> Gradient -> List (Attribute Message)
addMouseMoveHandler attributes maybeGradient gradient =
    case maybeGradient of
        Just g ->
            if g == gradient then
                let
                    moveHandler =
                        MouseEvents.onMouseMove
                            (MouseMoveInGradient gradient)
                in
                    moveHandler :: attributes
            else
                attributes

        Nothing ->
            attributes


gradientStyle : List Color -> ( String, String )
gradientStyle colors =
    [ "linear-gradient(to right, "
    , colors
        |> List.map toCssString
        |> List.intersperse ", "
        |> String.concat
    , ")"
    ]
        |> (String.concat >> (,) "background")


toCssString : Color -> String
toCssString color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
        [ "rgb("
        , toString red
        , ", "
        , toString green
        , ", "
        , toString blue
        , ")"
        ]
            |> String.concat
