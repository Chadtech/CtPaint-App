module ColorPicker.View exposing (view)

import Html exposing (Html, div, p, text, a, input, form)
import Html.Attributes exposing (class, classList, style, spellcheck, value)
import Html.Events exposing (onClick, onSubmit, onMouseDown, onFocus, onBlur, onInput)
import MouseEvents
import ColorPicker.Types exposing (..)
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
            (staticButtons model)
        ]



-- BUTTONS --


staticButtons : Model -> List (Html Message)
staticButtons ({ colorScale, colorHexField, color } as model) =
    let
        { red, green, blue } =
            Color.toRgb color
    in
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
        , slider "H" model.hueField HueFieldUpdate (hueGradient color)
        , slider "S" model.saturationField SaturationFieldUpdate (saturationGradient color)
        , slider "L" model.lightnessField LightnessFieldUpdate (lightnessGradient color)
        , slider "R" model.redField RedFieldUpdate (redGradient color)
        , slider "G" model.greenField GreenFieldUpdate (greenGradient color)
        , slider "B" model.blueField BlueFieldUpdate (blueGradient color)
        ]



-- SLIDERS --


slider : String -> String -> (String -> Message) -> Html Message -> Html Message
slider label fieldContent handler sliderGradient =
    div
        [ class "slider-container" ]
        [ p [] [ text label ]
        , sliderGradient
        , input
            [ onInput handler
            , value fieldContent
            ]
            []
        ]


redGradient : Color -> Html Message
redGradient color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
        div
            [ class "gradient"
            , style
                [ gradientStyle
                    [ Color.rgb 0 green blue
                    , Color.rgb 255 green blue
                    ]
                ]
            ]
            [ pointer red Red ]


greenGradient : Color -> Html Message
greenGradient color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
        div
            [ class "gradient"
            , style
                [ gradientStyle
                    [ Color.rgb red 0 blue
                    , Color.rgb red 255 blue
                    ]
                ]
            ]
            [ pointer green Green ]


blueGradient : Color -> Html Message
blueGradient color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
        div
            [ class "gradient"
            , style
                [ gradientStyle
                    [ Color.rgb red green 0
                    , Color.rgb red green 255
                    ]
                ]
            ]
            [ pointer blue Blue ]


hueGradient : Color -> Html Message
hueGradient color =
    let
        { red, green, blue } =
            Color.toRgb color

        { hue, saturation, lightness } =
            Color.toHsl color

        allEqual =
            Util.allTrue
                [ red == green
                , red == blue
                , blue == green
                ]

        nanSafeGradient =
            if allEqual then
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
    in
        div
            [ class "gradient"
            , style [ nanSafeGradient ]
            ]
            [ pointer
                (floor ((hue / (2 * pi)) * 255))
                Hue
            ]


saturationGradient : Color -> Html Message
saturationGradient color =
    let
        { red, green, blue } =
            Color.toRgb color

        { hue, saturation, lightness } =
            Color.toHsl color

        allEqual =
            Util.allTrue
                [ red == green
                , red == blue
                , blue == green
                ]

        nanSafeGradient =
            if allEqual then
                gradientStyle
                    [ Color.rgb red red red
                    , Color.rgb red red red
                    ]
            else
                gradientStyle
                    [ Color.hsl hue 0 lightness
                    , Color.hsl hue 1 lightness
                    ]
    in
        div
            [ class "gradient"
            , style [ nanSafeGradient ]
            ]
            [ pointer
                (floor (saturation * 255))
                Saturation
            ]


lightnessGradient : Color -> Html Message
lightnessGradient color =
    let
        { red, green, blue } =
            Color.toRgb color

        { hue, saturation, lightness } =
            Color.toHsl color

        allEqual =
            Util.allTrue
                [ red == green
                , red == blue
                , blue == green
                ]

        nanSafeGradient =
            if allEqual then
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
    in
        div
            [ class "gradient"
            , style [ nanSafeGradient ]
            ]
            [ pointer
                (floor (lightness * 255))
                Lightness
            ]


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


pointer : Int -> Gradient -> Html Message
pointer position gradient =
    div
        [ class "pointer"
        , style
            [ left (position - 2) ]
        , onMouseDown (MouseDownOnPointer gradient)
        ]
        []
