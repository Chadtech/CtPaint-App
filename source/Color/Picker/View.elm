module Color.Picker.View
    exposing
        ( css
        , view
        )

import Chadtech.Colors as Ct
import Color
import Color.Model as Model exposing (Model)
import Color.Picker.Data as Picker
    exposing
        ( Picker
        )
import Color.Picker.Data.Gradient
    exposing
        ( Gradient(..)
        )
import Color.Picker.Msg
    exposing
        ( Direction(Left, Right)
        , Msg(..)
        )
import Color.Util
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Html
    exposing
        ( Attribute
        , Html
        , div
        , form
        , input
        , p
        )
import Html.Attributes
    exposing
        ( spellcheck
        , style
        , value
        )
import Html.CssHelpers
import Html.Custom exposing (card, cardBody, header, indent)
import Html.Events
    exposing
        ( onBlur
        , onClick
        , onFocus
        , onInput
        , onSubmit
        )
import MouseEvents exposing (MouseEvent)
import Util exposing (def)


-- STYLES --


type Class
    = ColorPicker
    | Visualization
    | SliderLabel
    | SliderInput
    | SliderContainer
    | Gradient
    | Pointer
    | TriangleUp
    | TriangleDown
    | Transparent
    | HexField
    | ArrowButton
    | TriangleLeft
    | TriangleRight


css : Stylesheet
css =
    [ Css.class ColorPicker
        [ width (px 390)
        , position absolute
        ]
    , Css.class HexField
        [ margin (px 0)
        , marginTop (px 2)
        , display inlineBlock
        , minWidth minContent
        , verticalAlign top
        , children
            [ Css.Elements.input
                [ width (px 71)
                , marginLeft (px 2)
                ]
            ]
        ]
    , Css.class ArrowButton
        [ display inlineBlock
        , width (px 20)
        , height (px 20)
        , padding (px 0)
        , marginLeft (px 2)
        ]
    , Css.class TriangleRight
        [ width (px 0)
        , height (px 0)
        , marginLeft (px 5)
        , marginTop (px 5)
        , borderTop3 (px 5) solid transparent
        , borderBottom3 (px 5) solid transparent
        , borderLeft3 (px 10) solid Ct.point0
        ]
    , Css.class TriangleLeft
        [ width (px 0)
        , height (px 0)
        , marginLeft (px 5)
        , marginTop (px 5)
        , borderTop3 (px 5) solid transparent
        , borderBottom3 (px 5) solid transparent
        , borderRight3 (px 10) solid Ct.point0
        ]
    , (Css.class Visualization << List.append indent)
        [ height (px 20)
        , width (px 293)
        , verticalAlign top
        , display inlineBlock
        , marginTop (px 2)
        ]
    , Css.class SliderContainer
        [ marginTop (px 2)
        , width (pct 100)
        , height (px 25)
        , children
            [ Css.Elements.p
                [ display inlineBlock
                , verticalAlign top
                , marginTop (px 3)
                , marginLeft (px 2)
                ]
            , Css.Elements.input
                [ width (px 39)
                , verticalAlign top
                , marginLeft (px 2)
                ]
            ]
        ]
    , Css.class SliderLabel
        Html.Custom.cannotSelect
    , Css.class SliderInput
        Html.Custom.cannotSelect
    , (Css.class Gradient << List.append indent)
        [ height (px 20)
        , width (px 256)
        , display inlineBlock
        , marginLeft (px 4)
        , position relative
        , overflow hidden
        ]
    , Css.class Pointer
        [ position absolute

        --, width (px 8)
        , height (px 20)
        , cursor pointer
        ]
    , Css.class TriangleUp
        [ width (px 0)
        , height (px 0)
        , borderLeft3 (px 5) solid transparent
        , borderRight3 (px 5) solid transparent
        , borderTop3 (px 5) solid Ct.ignorable1
        ]
    , Css.class TriangleDown
        [ width (px 0)
        , height (px 0)
        , borderLeft3 (px 5) solid transparent
        , borderRight3 (px 5) solid transparent
        , borderBottom3 (px 5) solid Ct.point0
        , marginTop (px 10)
        ]
    , Css.class Transparent
        [ property "pointer-events" "none" ]
    ]
        |> namespace colorPickerNamespace
        |> stylesheet


colorPickerNamespace : String
colorPickerNamespace =
    Html.Custom.makeNamespace "ColorPicker"



-- VIEW --


{ class, classList } =
    Html.CssHelpers.withNamespace colorPickerNamespace


view : Model -> Html Msg
view model =
    if model.picker.show then
        card
            [ class [ ColorPicker ]
            , style
                [ Util.left model.picker.position.x
                , Util.top model.picker.position.y
                ]
            ]
            [ header
                { text = "color picker"
                , headerMouseDown = HeaderMouseDown
                , xButtonMouseDown = XButtonMouseDown
                , xButtonMouseUp = XButtonMouseUp
                }
            , cardBody [] (body model)
            ]
    else
        Html.text ""



-- BODY --


body : Model -> List (Html Msg)
body ({ picker } as model) =
    case Model.getPickersColor model of
        Just color ->
            [ div
                [ class [ Visualization ]
                , Color.Util.background color
                ]
                []
            , form
                [ class [ HexField ]
                , onSubmit StealSubmit
                ]
                [ input
                    [ spellcheck False
                    , onFocus InputFocused
                    , onBlur InputBlurred
                    , onInput HexFieldUpdated
                    , value picker.fields.colorHex
                    ]
                    []
                ]
            , slider
                { label = "H"
                , fieldContent = picker.fields.hue
                , gradient = Hue
                , gradientSlider = hueGradient color picker
                }
            , slider
                { label = "S"
                , fieldContent = picker.fields.saturation
                , gradient = Saturation
                , gradientSlider = saturationGradient color picker
                }
            , slider
                { label = "L"
                , fieldContent = picker.fields.lightness
                , gradient = Lightness
                , gradientSlider = lightnessGradient color picker
                }
            , slider
                { label = "R"
                , fieldContent = picker.fields.red
                , gradient = Red
                , gradientSlider = redGradient color picker
                }
            , slider
                { label = "G"
                , fieldContent = picker.fields.green
                , gradient = Green
                , gradientSlider = greenGradient color picker
                }
            , slider
                { label = "B"
                , fieldContent = picker.fields.blue
                , gradient = Blue
                , gradientSlider = blueGradient color picker
                }
            ]

        Nothing ->
            -- TODO
            -- Picker error view
            []


type alias SliderModel =
    { label : String
    , fieldContent : String
    , gradient : Gradient
    , gradientSlider : Html Msg
    }


slider : SliderModel -> Html Msg
slider { label, fieldContent, gradient, gradientSlider } =
    div
        [ class [ SliderContainer ] ]
        [ p [ class [ SliderLabel ] ] [ Html.text label ]
        , gradientSlider
        , arrow Left gradient TriangleLeft fieldContent
        , arrow Right gradient TriangleRight fieldContent
        , input
            [ class [ SliderInput ]
            , onInput (FieldUpdated gradient)
            , value fieldContent
            , onFocus InputFocused
            , onBlur InputBlurred
            ]
            []
        ]


arrow : Direction -> Gradient -> Class -> String -> Html Msg
arrow direction gradient triangleClass fieldContent =
    Html.Custom.menuButton
        [ class [ ArrowButton ]
        , onClick (ArrowClicked gradient direction)
        ]
        [ div [ class [ triangleClass ] ] [] ]



-- SLIDERS --


redGradient : Color.Color -> Picker -> Html Msg
redGradient color { gradientClickedOn } =
    let
        { red, green, blue } =
            Color.toRgb color

        attrs : List (Attribute Msg)
        attrs =
            [ Color.rgb 0 green blue
            , Color.rgb 255 green blue
            ]
                |> gradientStyle
                |> gradientAttributes Red
    in
    div
        attrs
        [ div
            [ pointerClasses gradientClickedOn Red
            , style [ Util.left (red - 5) ]
            , Html.Events.onMouseDown (MouseDownOnPointer Red)
            ]
            triangles
        ]


greenGradient : Color.Color -> Picker -> Html Msg
greenGradient color { gradientClickedOn } =
    let
        { red, green, blue } =
            Color.toRgb color

        attrs : List (Attribute Msg)
        attrs =
            [ Color.rgb red 0 blue
            , Color.rgb red 255 blue
            ]
                |> gradientStyle
                |> gradientAttributes Green
    in
    div
        attrs
        [ div
            [ pointerClasses gradientClickedOn Green
            , style [ Util.left (green - 5) ]
            , Html.Events.onMouseDown (MouseDownOnPointer Green)
            ]
            triangles
        ]


blueGradient : Color.Color -> Picker -> Html Msg
blueGradient color { gradientClickedOn } =
    let
        { red, green, blue } =
            Color.toRgb color

        attrs : List (Attribute Msg)
        attrs =
            [ Color.rgb red green 0
            , Color.rgb red green 255
            ]
                |> gradientStyle
                |> gradientAttributes Blue
    in
    div
        attrs
        [ div
            [ pointerClasses gradientClickedOn Blue
            , style [ Util.left (blue - 5) ]
            , Html.Events.onMouseDown (MouseDownOnPointer Blue)
            ]
            triangles
        ]


hueGradient : Color.Color -> Picker -> Html Msg
hueGradient color { gradientClickedOn } =
    let
        { red } =
            Color.toRgb color

        { hue, saturation, lightness } =
            Color.toHsl color

        style_ : ( String, String )
        style_ =
            if Color.Util.doesntHaveHue color then
                [ Color.rgb red red red
                , Color.rgb red red red
                ]
                    |> gradientStyle
            else
                let
                    atDegree : Float -> Color.Color
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
        (gradientAttributes Hue style_)
        [ div
            [ pointerClasses gradientClickedOn Hue
            , style [ Util.left (hueLeftPosition hue) ]
            , Html.Events.onMouseDown
                (MouseDownOnPointer Hue)
            ]
            triangles
        ]


hueLeftPosition : Float -> Int
hueLeftPosition hue =
    floor ((hue / (2 * pi)) * 255) - 5


saturationGradient : Color.Color -> Picker -> Html Msg
saturationGradient color { gradientClickedOn } =
    let
        { hue, saturation, lightness } =
            Color.toHsl color

        style_ : ( String, String )
        style_ =
            if Color.Util.doesntHaveHue color then
                let
                    { red } =
                        Color.toRgb color
                in
                [ Color.rgb red red red
                , Color.rgb red red red
                ]
                    |> gradientStyle
            else
                [ Color.hsl hue 0 lightness
                , Color.hsl hue 1 lightness
                ]
                    |> gradientStyle
    in
    div
        (gradientAttributes Saturation style_)
        [ div
            [ pointerClasses gradientClickedOn Saturation
            , style
                [ Util.left (floor (saturation * 255) - 5) ]
            , Html.Events.onMouseDown
                (MouseDownOnPointer Saturation)
            ]
            triangles
        ]


lightnessGradient : Color.Color -> Picker -> Html Msg
lightnessGradient color { gradientClickedOn } =
    let
        { hue, saturation, lightness } =
            Color.toHsl color

        gradientColors : List Color.Color
        gradientColors =
            if Color.Util.doesntHaveHue color then
                [ Color.rgb 0 0 0
                , Color.rgb 255 255 255
                ]
            else
                [ Color.hsl hue saturation 0
                , Color.hsl hue saturation 0.5
                , Color.hsl hue saturation 1
                ]
    in
    div
        (gradientAttributes Lightness (gradientStyle gradientColors))
        [ div
            [ pointerClasses gradientClickedOn Lightness
            , style
                [ Util.left (floor (lightness * 255) - 5) ]
            , Html.Events.onMouseDown (MouseDownOnPointer Lightness)
            ]
            triangles
        ]


pointerClasses : Maybe Gradient -> Gradient -> Attribute msg
pointerClasses gradientClickedOn thisGradient =
    [ def Pointer True
    , def
        Transparent
        (gradientClickedOn == Just thisGradient)
    ]
        |> classList


triangles : List (Html msg)
triangles =
    [ div [ class [ TriangleUp ] ] []
    , div [ class [ TriangleDown ] ] []
    ]



-- INTERNAL HELPERS --


gradientAttributes : Gradient -> ( String, String ) -> List (Attribute Msg)
gradientAttributes gradient gradientStyle_ =
    [ class [ Gradient ]
    , style [ gradientStyle_ ]
    , MouseEvents.onMouseDown (GradientMouseDown gradient)
    , MouseEvents.onMouseMove (MouseMoveInGradient gradient)
    ]


gradientStyle : List Color.Color -> ( String, String )
gradientStyle colors =
    [ "linear-gradient(to right, "
    , colors
        |> List.map toCssString
        |> List.intersperse ", "
        |> String.concat
    , ")"
    ]
        |> String.concat
        |> def "background"


toCssString : Color.Color -> String
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
