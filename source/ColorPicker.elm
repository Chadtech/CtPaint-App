module ColorPicker
    exposing
        ( css
        , subscriptions
        , update
        , view
        )

import Bool.Extra
import Chadtech.Colors as Ct
import Color
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Picker
    exposing
        ( ClickState(..)
        , Direction(Left, Right)
        , Gradient(..)
        , Model
        , Msg(..)
        , Reply(..)
        )
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
import Mouse
import MouseEvents exposing (MouseEvent)
import Ports
import Return2 as R2
import Return3 as R3 exposing (Return)
import Util exposing (def, toColor)


-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.show then
        [ Mouse.moves ClientMouseMove
        , Mouse.ups (always ClientMouseUp)
        ]
            |> Sub.batch
    else
        Sub.none



-- UTIL --


doesntHaveHue : Color.Color -> Bool
doesntHaveHue color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
    [ red == green
    , green == blue
    , blue == red
    ]
        |> Bool.Extra.all



-- UPDATE --


calcGradientX : MouseEvent -> Int
calcGradientX { targetPos, clientPos } =
    (clientPos.x - targetPos.x - 4)
        |> min 255
        |> max 0


movedInCurrentGradient : Model -> Gradient -> Bool
movedInCurrentGradient { gradientClickedOn } gradient =
    gradientClickedOn
        |> Maybe.map ((==) gradient)
        |> Maybe.withDefault False


update : Msg -> Model -> Return Model Msg Reply
update msg model =
    case msg of
        HeaderMouseDown mouseEvent ->
            case model.headerClickState of
                XButtonIsDown ->
                    model
                        |> R3.withNothing

                _ ->
                    { model
                        | headerClickState =
                            mouseEvent
                                |> Util.elRel
                                |> ClickAt
                    }
                        |> R3.withNothing

        XButtonMouseDown ->
            { model | headerClickState = XButtonIsDown }
                |> R3.withNothing

        XButtonMouseUp ->
            { model
                | show = False
                , headerClickState = NoClicks
            }
                |> R3.withNothing

        InputFocused ->
            model
                |> R2.withCmd Ports.stealFocus
                |> R3.withNoReply

        InputBlurred ->
            model
                |> R2.withCmd Ports.returnFocus
                |> R3.withNoReply

        HexFieldUpdated hex ->
            let
                newHexField =
                    String.toUpper hex
            in
            case toColor newHexField of
                Just color ->
                    { model
                        | color = color
                        , colorHexField = newHexField
                    }
                        |> cohereAndSet

                Nothing ->
                    { model
                        | colorHexField = newHexField
                    }
                        |> R3.withNothing

        StealSubmit ->
            model |> R3.withNothing

        GradientMouseDown gradient event ->
            { model
                | gradientClickedOn = Just gradient
            }
                |> setGradient (calcGradientX event) gradient

        MouseDownOnPointer gradient ->
            { model
                | gradientClickedOn = Just gradient
            }
                |> R2.withNoCmd
                |> R3.withReply
                    (UpdateHistory model.index model.color)

        MouseMoveInGradient gradient event ->
            if movedInCurrentGradient model gradient then
                setGradient (calcGradientX event) gradient model
            else
                model
                    |> R3.withNothing

        FieldUpdated gradient str ->
            fieldHandler gradient str model

        ArrowClicked gradient direction ->
            arrowHandler gradient direction model

        ClientMouseUp ->
            { model
                | headerClickState = NoClicks
                , gradientClickedOn = Nothing
            }
                |> R3.withNothing

        ClientMouseMove position ->
            { model
                | position =
                    case model.headerClickState of
                        NoClicks ->
                            model.position

                        XButtonIsDown ->
                            model.position

                        ClickAt originalClick ->
                            { x = position.x - originalClick.x
                            , y = position.y - originalClick.y
                            }
            }
                |> R3.withNothing



-- MESSAGE HANDLERS --


arrowHandler : Gradient -> Direction -> Model -> Return Model Msg Reply
arrowHandler gradient direction model =
    let
        { hue, saturation, lightness } =
            Color.toHsl model.color

        { red, green, blue } =
            Color.toRgb model.color
    in
    case gradient of
        Lightness ->
            let
                lightnessInt =
                    Basics.round (lightness * 255)
            in
            case direction of
                Left ->
                    if 0 < lightnessInt then
                        { model
                            | color =
                                Color.hsl
                                    hue
                                    saturation
                                    (toFloat (lightnessInt - 1) / 255)
                        }
                            |> cohereAndSet
                    else
                        model
                            |> R3.withNothing

                Right ->
                    if lightnessInt < 255 then
                        { model
                            | color =
                                Color.hsl
                                    hue
                                    saturation
                                    (toFloat (lightnessInt + 1) / 255)
                        }
                            |> cohereAndSet
                    else
                        model
                            |> R3.withNothing

        Saturation ->
            let
                saturationInt =
                    Basics.round (saturation * 255)
            in
            case direction of
                Left ->
                    if 0 < saturationInt then
                        { model
                            | color =
                                Color.hsl
                                    hue
                                    (toFloat (saturationInt - 1) / 255)
                                    lightness
                        }
                            |> cohereAndSet
                    else
                        model
                            |> R3.withNothing

                Right ->
                    if saturationInt < 255 then
                        { model
                            | color =
                                Color.hsl
                                    hue
                                    (toFloat (saturationInt + 1) / 255)
                                    lightness
                        }
                            |> cohereAndSet
                    else
                        model
                            |> R3.withNothing

        Hue ->
            let
                newHue =
                    let
                        d =
                            case direction of
                                Left ->
                                    -1

                                Right ->
                                    1
                    in
                    (Basics.round ((hue * 180 / pi) + d) % 360)
                        |> toFloat
                        |> degrees
            in
            { model
                | color =
                    Color.hsl
                        newHue
                        saturation
                        lightness
            }
                |> cohereAndSet

        Red ->
            case direction of
                Left ->
                    if 0 < red then
                        { model
                            | color =
                                Color.rgb
                                    (red - 1)
                                    green
                                    blue
                        }
                            |> cohereAndSet
                    else
                        model
                            |> R3.withNothing

                Right ->
                    if red < 255 then
                        { model
                            | color =
                                Color.rgb
                                    (red + 1)
                                    green
                                    blue
                        }
                            |> cohereAndSet
                    else
                        model
                            |> R3.withNothing

        Green ->
            case direction of
                Left ->
                    if 0 < green then
                        { model
                            | color =
                                Color.rgb
                                    red
                                    (green - 1)
                                    blue
                        }
                            |> cohereAndSet
                    else
                        model
                            |> R3.withNothing

                Right ->
                    if green < 255 then
                        { model
                            | color =
                                Color.rgb
                                    red
                                    (green + 1)
                                    blue
                        }
                            |> cohereAndSet
                    else
                        model
                            |> R3.withNothing

        Blue ->
            case direction of
                Left ->
                    if 0 < blue then
                        { model
                            | color =
                                Color.rgb
                                    red
                                    green
                                    (blue - 1)
                        }
                            |> cohereAndSet
                    else
                        model
                            |> R3.withNothing

                Right ->
                    if blue < 255 then
                        { model
                            | color =
                                Color.rgb
                                    red
                                    green
                                    (blue + 1)
                        }
                            |> cohereAndSet
                    else
                        model
                            |> R3.withNothing


fieldHandler : Gradient -> String -> Model -> Return Model Msg Reply
fieldHandler gradient str model =
    case String.toInt str of
        Ok int ->
            fieldHandlerOk gradient str int model

        Err _ ->
            fieldHandlerErr gradient str model
                |> R3.withNothing


fieldHandlerOk : Gradient -> String -> Int -> Model -> Return Model Msg Reply
fieldHandlerOk gradient str int model =
    let
        { hue, saturation, lightness } =
            Color.toHsl model.color

        { red, green, blue } =
            Color.toRgb model.color
    in
    case gradient of
        Lightness ->
            { model
                | lightnessField = str
                , color =
                    Color.hsl
                        hue
                        saturation
                        (toFloat int / 255)
            }
                |> cohereAndSet

        Saturation ->
            { model
                | saturationField = str
                , color =
                    Color.hsl
                        hue
                        (toFloat int / 255)
                        lightness
            }
                |> cohereAndSet

        Hue ->
            { model
                | hueField = str
                , color =
                    Color.hsl
                        (degrees (toFloat int))
                        saturation
                        lightness
            }
                |> cohereAndSet

        Blue ->
            { model
                | blueField = str
                , color =
                    validateHue
                        model.color
                        (Color.rgb red green int)
                        int
            }
                |> cohereAndSet

        Green ->
            { model
                | greenField = str
                , color =
                    validateHue
                        model.color
                        (Color.rgb red int blue)
                        int
            }
                |> cohereAndSet

        Red ->
            { model
                | redField = str
                , color =
                    validateHue
                        model.color
                        (Color.rgb int green blue)
                        int
            }
                |> cohereAndSet


validateHue : Color.Color -> Color.Color -> Int -> Color.Color
validateHue oldColor newColor int =
    if doesntHaveHue newColor then
        let
            { hue, lightness } =
                Color.toHsl oldColor
        in
        Color.hsl
            hue
            (toFloat int / 255)
            lightness
    else
        newColor


fieldHandlerErr : Gradient -> String -> Model -> Model
fieldHandlerErr gradient str model =
    case gradient of
        Lightness ->
            { model | lightnessField = str }

        Saturation ->
            { model | saturationField = str }

        Hue ->
            { model | hueField = str }

        Blue ->
            { model | blueField = str }

        Green ->
            { model | greenField = str }

        Red ->
            { model | redField = str }


setGradient : Int -> Gradient -> Model -> Return Model Msg Reply
setGradient x gradient model =
    case gradient of
        Lightness ->
            let
                { hue, saturation } =
                    Color.toHsl model.color
            in
            { model
                | color =
                    Color.hsl
                        hue
                        saturation
                        (toFloat x / 255)
            }
                |> cohereAndSet

        Saturation ->
            let
                { hue, lightness } =
                    Color.toHsl model.color
            in
            { model
                | color =
                    Color.hsl
                        (Util.filterNan hue)
                        (toFloat x / 255)
                        lightness
            }
                |> cohereAndSet

        Hue ->
            let
                { saturation, lightness } =
                    Color.toHsl model.color
            in
            { model
                | color =
                    Color.hsl
                        (degrees ((toFloat x / 255) * 360))
                        saturation
                        lightness
            }
                |> cohereAndSet

        Red ->
            let
                { green, blue } =
                    Color.toRgb model.color
            in
            { model
                | color = Color.rgb x green blue
            }
                |> cohereAndSet

        Green ->
            let
                { red, blue } =
                    Color.toRgb model.color
            in
            { model
                | color = Color.rgb red x blue
            }
                |> cohereAndSet

        Blue ->
            let
                { red, green } =
                    Color.toRgb model.color
            in
            { model
                | color = Color.rgb red green x
            }
                |> cohereAndSet



-- INTERNAL HELPERS --


cohereAndSet : Model -> Return Model Msg Reply
cohereAndSet =
    cohereModel >> setColor


setColor : Model -> Return Model Msg Reply
setColor ({ index, color } as model) =
    model
        |> R2.withNoCmd
        |> R3.withReply (SetColor index color)


cohereModel : Model -> Model
cohereModel model =
    let
        { red, green, blue } =
            Color.toRgb model.color

        { hue, saturation, lightness } =
            Color.toHsl model.color
    in
    { model
        | redField = toString red
        , greenField = toString green
        , blueField = toString blue
        , hueField =
            (radians hue / (2 * pi) * 360)
                |> floor
                |> toString
        , saturationField =
            (saturation * 255)
                |> floor
                |> toString
        , lightnessField =
            (lightness * 255)
                |> floor
                |> toString
        , colorHexField =
            model.color
                |> Util.toHexColor
                |> String.dropLeft 1
    }



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
    card
        [ class [ ColorPicker ]
        , style
            [ Util.left model.position.x
            , Util.top model.position.y
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



-- BODY --


body : Model -> List (Html Msg)
body ({ colorHexField, color } as model) =
    [ div
        [ class [ Visualization ]
        , style
            [ def "background" <| Util.toHexColor color ]
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
            , value colorHexField
            ]
            []
        ]
    , slider
        { label = "H"
        , fieldContent = model.hueField
        , gradient = Hue
        , gradientSlider = hueGradient model
        }
    , slider
        { label = "S"
        , fieldContent = model.saturationField
        , gradient = Saturation
        , gradientSlider = saturationGradient model
        }
    , slider
        { label = "L"
        , fieldContent = model.lightnessField
        , gradient = Lightness
        , gradientSlider = lightnessGradient model
        }
    , slider
        { label = "R"
        , fieldContent = model.redField
        , gradient = Red
        , gradientSlider = redGradient model
        }
    , slider
        { label = "G"
        , fieldContent = model.greenField
        , gradient = Green
        , gradientSlider = greenGradient model
        }
    , slider
        { label = "B"
        , fieldContent = model.blueField
        , gradient = Blue
        , gradientSlider = blueGradient model
        }
    ]


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


redGradient : Model -> Html Msg
redGradient { color, gradientClickedOn } =
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


greenGradient : Model -> Html Msg
greenGradient { color, gradientClickedOn } =
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


blueGradient : Model -> Html Msg
blueGradient { color, gradientClickedOn } =
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


hueGradient : Model -> Html Msg
hueGradient { color, gradientClickedOn } =
    let
        { red } =
            Color.toRgb color

        { hue, saturation, lightness } =
            Color.toHsl color

        style_ : ( String, String )
        style_ =
            if doesntHaveHue color then
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


saturationGradient : Model -> Html Msg
saturationGradient { color, gradientClickedOn } =
    let
        { hue, saturation, lightness } =
            Color.toHsl color

        style_ : ( String, String )
        style_ =
            if doesntHaveHue color then
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


lightnessGradient : Model -> Html Msg
lightnessGradient { color, gradientClickedOn } =
    let
        { hue, saturation, lightness } =
            Color.toHsl color

        gradientColors : List Color.Color
        gradientColors =
            if doesntHaveHue color then
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
