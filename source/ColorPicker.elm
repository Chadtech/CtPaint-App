module ColorPicker
    exposing
        ( css
        , subscriptions
        , update
        , view
        )

import Bool.Extra
import Chadtech.Colors exposing (ignorable1, point)
import Color
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Picker
    exposing
        ( ClickState(..)
        , Direction(Left, Right)
        , Fields
        , FieldsMsg(..)
        , Gradient(..)
        , Model
        , Msg(..)
        , Reply(..)
        , Window
        , WindowMsg(..)
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
import Tuple.Infix exposing ((&), (:=))
import Util exposing (toColor)


-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions { window } =
    if window.show && window.clickState /= NoClicks then
        Sub.batch
            [ Mouse.moves
                (HandleWindowMsg << HeaderMouseMove)
            , Mouse.ups
                (always (HandleWindowMsg HeaderMouseUp))
            ]
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


integrateFields : Model -> Fields -> Model
integrateFields model fields =
    { model | fields = fields }


integrateWindow : Model -> Window -> Model
integrateWindow model window =
    { model | window = window }


updateFields : FieldsMsg -> Fields -> ( Fields, Reply )
updateFields msg fields =
    case msg of
        SetFocus True ->
            fields & StealFocus

        SetFocus False ->
            fields & ReturnFocus

        UpdateColorHexField hex ->
            let
                newHexField =
                    String.toUpper hex
            in
            case toColor newHexField of
                Just color ->
                    { fields
                        | color = color
                        , colorHexField = newHexField
                    }
                        |> cohereAndSet

                Nothing ->
                    { fields
                        | colorHexField = newHexField
                    }
                        & NoReply

        StealSubmit ->
            fields & NoReply

        SetNoGradientClickedOn ->
            { fields
                | gradientClickedOn = Nothing
            }
                & NoReply

        MouseDownOnPointer gradient ->
            { fields
                | gradientClickedOn = Just gradient
            }
                & UpdateHistory fields.index fields.color

        MouseMoveInGradient gradient { targetPos, clientPos } ->
            let
                x =
                    (clientPos.x - targetPos.x - 4)
                        |> min 255
                        |> max 0
            in
            sliderHandler x gradient fields

        FieldUpdate gradient str ->
            fieldHandler gradient str fields

        ArrowClicked gradient direction ->
            arrowHandler gradient direction fields


updateWindow : WindowMsg -> Window -> ( Window, Reply )
updateWindow msg window =
    case msg of
        HeaderMouseDown { targetPos, clientPos } ->
            case window.clickState of
                XButtonIsDown ->
                    window & NoReply

                _ ->
                    { window
                        | clickState =
                            { x = clientPos.x - targetPos.x
                            , y = clientPos.y - targetPos.y
                            }
                                |> ClickAt
                    }
                        & NoReply

        HeaderMouseMove position ->
            case window.clickState of
                NoClicks ->
                    window & NoReply

                XButtonIsDown ->
                    window & NoReply

                ClickAt originalClick ->
                    { window
                        | position =
                            { x = position.x - originalClick.x
                            , y = position.y - originalClick.y
                            }
                    }
                        & NoReply

        HeaderMouseUp ->
            { window | clickState = NoClicks }
                & NoReply

        XButtonMouseDown ->
            { window | clickState = XButtonIsDown }
                & NoReply

        XButtonMouseUp ->
            { window
                | show = False
                , clickState = NoClicks
            }
                & NoReply


update : Msg -> Model -> ( Model, Reply )
update message model =
    case message of
        HandleFieldsMsg fieldsMsg ->
            model.fields
                |> updateFields fieldsMsg
                |> Tuple.mapFirst (integrateFields model)

        HandleWindowMsg windowMsg ->
            model.window
                |> updateWindow windowMsg
                |> Tuple.mapFirst (integrateWindow model)



-- MESSAGE HANDLERS --


arrowHandler : Gradient -> Direction -> Fields -> ( Fields, Reply )
arrowHandler gradient direction fields =
    let
        { hue, saturation, lightness } =
            Color.toHsl fields.color

        { red, green, blue } =
            Color.toRgb fields.color
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
                        { fields
                            | color =
                                Color.hsl
                                    hue
                                    saturation
                                    (toFloat (lightnessInt - 1) / 255)
                        }
                            |> cohereAndSet
                    else
                        fields & NoReply

                Right ->
                    if lightnessInt < 255 then
                        { fields
                            | color =
                                Color.hsl
                                    hue
                                    saturation
                                    (toFloat (lightnessInt + 1) / 255)
                        }
                            |> cohereAndSet
                    else
                        fields & NoReply

        Saturation ->
            let
                saturationInt =
                    Basics.round (saturation * 255)
            in
            case direction of
                Left ->
                    if 0 < saturationInt then
                        { fields
                            | color =
                                Color.hsl
                                    hue
                                    (toFloat (saturationInt - 1) / 255)
                                    lightness
                        }
                            |> cohereAndSet
                    else
                        fields & NoReply

                Right ->
                    if saturationInt < 255 then
                        { fields
                            | color =
                                Color.hsl
                                    hue
                                    (toFloat (saturationInt + 1) / 255)
                                    lightness
                        }
                            |> cohereAndSet
                    else
                        fields & NoReply

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
            { fields
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
                        { fields
                            | color =
                                Color.rgb
                                    (red - 1)
                                    green
                                    blue
                        }
                            |> cohereAndSet
                    else
                        fields & NoReply

                Right ->
                    if red < 255 then
                        { fields
                            | color =
                                Color.rgb
                                    (red + 1)
                                    green
                                    blue
                        }
                            |> cohereAndSet
                    else
                        fields & NoReply

        Green ->
            case direction of
                Left ->
                    if 0 < green then
                        { fields
                            | color =
                                Color.rgb
                                    red
                                    (green - 1)
                                    blue
                        }
                            |> cohereAndSet
                    else
                        fields & NoReply

                Right ->
                    if green < 255 then
                        { fields
                            | color =
                                Color.rgb
                                    red
                                    (green + 1)
                                    blue
                        }
                            |> cohereAndSet
                    else
                        fields & NoReply

        Blue ->
            case direction of
                Left ->
                    if 0 < blue then
                        { fields
                            | color =
                                Color.rgb
                                    red
                                    green
                                    (blue - 1)
                        }
                            |> cohereAndSet
                    else
                        fields & NoReply

                Right ->
                    if blue < 255 then
                        { fields
                            | color =
                                Color.rgb
                                    red
                                    green
                                    (blue + 1)
                        }
                            |> cohereAndSet
                    else
                        fields & NoReply


fieldHandler : Gradient -> String -> Fields -> ( Fields, Reply )
fieldHandler gradient str fields =
    case String.toInt str of
        Ok int ->
            fieldHandlerOk gradient str int fields

        Err _ ->
            fieldHandlerErr gradient str fields


fieldHandlerOk : Gradient -> String -> Int -> Fields -> ( Fields, Reply )
fieldHandlerOk gradient str int fields =
    let
        { hue, saturation, lightness } =
            Color.toHsl fields.color

        { red, green, blue } =
            Color.toRgb fields.color
    in
    case gradient of
        Lightness ->
            { fields
                | lightnessField = str
                , color =
                    Color.hsl
                        hue
                        saturation
                        (toFloat int / 255)
            }
                |> cohereAndSet

        Saturation ->
            { fields
                | saturationField = str
                , color =
                    Color.hsl
                        hue
                        (toFloat int / 255)
                        lightness
            }
                |> cohereAndSet

        Hue ->
            { fields
                | hueField = str
                , color =
                    Color.hsl
                        (degrees (toFloat int))
                        saturation
                        lightness
            }
                |> cohereAndSet

        Blue ->
            { fields
                | blueField = str
                , color =
                    validateHue
                        fields.color
                        (Color.rgb red green int)
                        int
            }
                |> cohereAndSet

        Green ->
            { fields
                | greenField = str
                , color =
                    validateHue
                        fields.color
                        (Color.rgb red int blue)
                        int
            }
                |> cohereAndSet

        Red ->
            { fields
                | redField = str
                , color =
                    validateHue
                        fields.color
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


fieldHandlerErr : Gradient -> String -> Fields -> ( Fields, Reply )
fieldHandlerErr gradient str fields =
    case gradient of
        Lightness ->
            { fields | lightnessField = str } & NoReply

        Saturation ->
            { fields | saturationField = str } & NoReply

        Hue ->
            { fields | hueField = str } & NoReply

        Blue ->
            { fields | blueField = str } & NoReply

        Green ->
            { fields | greenField = str } & NoReply

        Red ->
            { fields | redField = str } & NoReply


sliderHandler : Int -> Gradient -> Fields -> ( Fields, Reply )
sliderHandler x gradient fields =
    case gradient of
        Lightness ->
            let
                { hue, saturation } =
                    Color.toHsl fields.color
            in
            { fields
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
                    Color.toHsl fields.color
            in
            { fields
                | color =
                    Color.hsl
                        hue
                        (toFloat x / 255)
                        lightness
            }
                |> cohereAndSet

        Hue ->
            let
                { saturation, lightness } =
                    Color.toHsl fields.color
            in
            { fields
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
                    Color.toRgb fields.color
            in
            { fields
                | color = Color.rgb x green blue
            }
                |> cohereAndSet

        Green ->
            let
                { red, blue } =
                    Color.toRgb fields.color
            in
            { fields
                | color = Color.rgb red x blue
            }
                |> cohereAndSet

        Blue ->
            let
                { red, green } =
                    Color.toRgb fields.color
            in
            { fields
                | color = Color.rgb red green x
            }
                |> cohereAndSet



-- INTERNAL HELPERS --


cohereAndSet : Fields -> ( Fields, Reply )
cohereAndSet =
    cohereModel >> setColor


setColor : Fields -> ( Fields, Reply )
setColor ({ index, color } as fields) =
    fields & SetColor index color


cohereModel : Fields -> Fields
cohereModel fields =
    let
        { red, green, blue } =
            Color.toRgb fields.color

        { hue, saturation, lightness } =
            Color.toHsl fields.color
    in
    { fields
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
            fields.color
                |> Util.toHexColor
                |> String.dropLeft 1
    }



-- STYLES --


type Class
    = ColorPicker
    | Visualization
    | SliderContainer
    | Gradient
    | Pointer
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
        , borderLeft3 (px 10) solid point
        ]
    , Css.class TriangleLeft
        [ width (px 0)
        , height (px 0)
        , marginLeft (px 5)
        , marginTop (px 5)
        , borderTop3 (px 5) solid transparent
        , borderBottom3 (px 5) solid transparent
        , borderRight3 (px 10) solid point
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
    , (Css.class Gradient << List.append indent)
        [ height (px 20)
        , width (px 256)
        , display inlineBlock
        , marginLeft (px 4)
        , position relative
        ]
    , Css.class Pointer
        [ position absolute
        , height (px 20)
        , borderLeft3 (px 2) solid point
        , borderRight3 (px 2) solid ignorable1
        , cursor pointer
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
            [ Util.left model.window.position.x
            , Util.top model.window.position.y
            ]
        ]
        [ (header >> Html.map HandleWindowMsg)
            { text = "color picker"
            , headerMouseDown = HeaderMouseDown
            , xButtonMouseDown = XButtonMouseDown
            , xButtonMouseUp = XButtonMouseUp
            }
        , cardBody [] (body model.fields)
            |> Html.map HandleFieldsMsg
        ]



-- BODY --


body : Fields -> List (Html FieldsMsg)
body ({ colorHexField, color } as model) =
    [ div
        [ class [ Visualization ]
        , style
            [ "background" := Util.toHexColor color ]
        ]
        []
    , form
        [ class [ HexField ]
        , onSubmit StealSubmit
        ]
        [ input
            [ spellcheck False
            , onFocus (SetFocus True)
            , onBlur (SetFocus False)
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


slider : String -> String -> Gradient -> Html FieldsMsg -> Html FieldsMsg
slider label fieldContent gradient sliderGradient =
    div
        [ class [ SliderContainer ] ]
        [ p [] [ Html.text label ]
        , sliderGradient
        , arrow Left gradient TriangleLeft fieldContent
        , arrow Right gradient TriangleRight fieldContent
        , input
            [ onInput (FieldUpdate gradient)
            , value fieldContent
            , onFocus (SetFocus True)
            , onBlur (SetFocus False)
            ]
            []
        ]


arrow : Direction -> Gradient -> Class -> String -> Html FieldsMsg
arrow direction gradient triangleClass fieldContent =
    Html.Custom.menuButton
        [ class [ ArrowButton ]
        , onClick (ArrowClicked gradient direction)
        ]
        [ div [ class [ triangleClass ] ] [] ]



-- SLIDERS --


redGradient : Fields -> Html FieldsMsg
redGradient { color, gradientClickedOn } =
    let
        { red, green, blue } =
            Color.toRgb color

        attributes : List (Attribute FieldsMsg)
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
                , "transparent" := (gradientClickedOn == Just Red)
                ]
            , style [ Util.left (red - 2) ]
            , Html.Events.onMouseDown (MouseDownOnPointer Red)
            ]
            []
        ]


greenGradient : Fields -> Html FieldsMsg
greenGradient { color, gradientClickedOn } =
    let
        { red, green, blue } =
            Color.toRgb color

        attributes : List (Attribute FieldsMsg)
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
                , "transparent" := (gradientClickedOn == Just Green)
                ]
            , style [ Util.left (green - 2) ]
            , Html.Events.onMouseDown (MouseDownOnPointer Green)
            ]
            []
        ]


blueGradient : Fields -> Html FieldsMsg
blueGradient { color, gradientClickedOn } =
    let
        { red, green, blue } =
            Color.toRgb color

        attributes : List (Attribute FieldsMsg)
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
                , "transparent" := (gradientClickedOn == Just Blue)
                ]
            , style [ Util.left (blue - 2) ]
            , Html.Events.onMouseDown (MouseDownOnPointer Blue)
            ]
            []
        ]


hueGradient : Fields -> Html FieldsMsg
hueGradient { color, gradientClickedOn } =
    let
        { red } =
            Color.toRgb color

        { hue, saturation, lightness } =
            Color.toHsl color

        nanSafeGradient =
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

        attributes : List (Attribute FieldsMsg)
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
                , "transparent" := (gradientClickedOn == Just Hue)
                ]
            , style
                [ Util.left (floor ((hue / (2 * pi)) * 255)) ]
            , Html.Events.onMouseDown (MouseDownOnPointer Hue)
            ]
            []
        ]


saturationGradient : Fields -> Html FieldsMsg
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
                [ Color.rgb red red red
                , Color.rgb red red red
                ]
                    |> gradientStyle
            else
                [ Color.hsl hue 0 lightness
                , Color.hsl hue 1 lightness
                ]
                    |> gradientStyle

        attributes : List (Attribute FieldsMsg)
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
                , "transparent" := (gradientClickedOn == Just Saturation)
                ]
            , style
                [ Util.left (floor (saturation * 255) - 2) ]
            , Html.Events.onMouseDown (MouseDownOnPointer Saturation)
            ]
            []
        ]


lightnessGradient : Fields -> Html FieldsMsg
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

        attributes : List (Attribute FieldsMsg)
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
                , "transparent" := (gradientClickedOn == Just Lightness)
                ]
            , style
                [ Util.left (floor (lightness * 255) - 2) ]
            , Html.Events.onMouseDown (MouseDownOnPointer Lightness)
            ]
            []
        ]



-- INTERNAL HELPERS --


gradientAttributes : ( String, String ) -> List (Attribute FieldsMsg)
gradientAttributes gradientStyle_ =
    [ class [ Gradient ]
    , style [ gradientStyle_ ]
    , Html.Events.onMouseUp SetNoGradientClickedOn
    ]


addMouseMoveHandler : List (Attribute FieldsMsg) -> Maybe Gradient -> Gradient -> List (Attribute FieldsMsg)
addMouseMoveHandler attributes maybeGradient gradient =
    case maybeGradient of
        Just g ->
            if g == gradient then
                let
                    moveHandler =
                        MouseMoveInGradient gradient
                            |> MouseEvents.onMouseMove
                in
                moveHandler :: attributes
            else
                attributes

        Nothing ->
            attributes


gradientStyle : List Color.Color -> ( String, String )
gradientStyle colors =
    [ "linear-gradient(to right, "
    , colors
        |> List.map toCssString
        |> List.intersperse ", "
        |> String.concat
    , ")"
    ]
        |> (String.concat >> (,) "background")


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
