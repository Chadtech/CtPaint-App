module ColorPicker
    exposing
        ( Model
        , Msg(..)
        , Reply(..)
        , css
        , init
        , subscriptions
        , update
        , view
        )

import Bool.Extra
import Chadtech.Colors exposing (ignorable1, point)
import Color exposing (Color)
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Html
    exposing
        ( Attribute
        , Html
        , a
        , div
        , form
        , input
        , p
        , text
        )
import Html.Attributes
    exposing
        ( class
        , classList
        , spellcheck
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


-- TYPES --


type Reply
    = NoReply
    | SetColor Int Color.Color
    | UpdateHistory Int Color.Color
    | StealFocus
    | ReturnFocus


type WindowMsg
    = HeaderMouseDown MouseEvent
    | HeaderMouseMove Mouse.Position
    | HeaderMouseUp
    | Close


type PickerMsg
    = SetFocus Bool
    | StealSubmit
    | UpdateColorHexField String
    | MouseDownOnPointer Gradient
    | SetNoGradientClickedOn
    | MouseMoveInGradient Gradient MouseEvent
    | FieldUpdate Gradient String


type Msg
    = HandlePickerMsg PickerMsg
    | HandleWindowMsg WindowMsg


type Gradient
    = Red
    | Green
    | Blue
    | Hue
    | Saturation
    | Lightness


type alias Model =
    { window : Window
    , picker : Picker
    }


type alias Window =
    { position : Mouse.Position
    , clickState : Maybe Mouse.Position
    , focusedOn : Bool
    , show : Bool
    }


type alias Picker =
    { color : Color.Color
    , index : Int
    , redField : String
    , greenField : String
    , blueField : String
    , hueField : String
    , saturationField : String
    , lightnessField : String
    , colorHexField : String
    , gradientClickedOn : Maybe Gradient
    }



-- INIT --


init : Bool -> Int -> Color.Color -> Model
init show index color =
    { picker = initPicker index color
    , window = initWindow show
    }


initPicker : Int -> Color.Color -> Picker
initPicker index color =
    let
        { red, green, blue } =
            Color.toRgb color

        { hue, saturation, lightness } =
            Color.toHsl color
    in
    { color = color
    , index = index
    , redField = toString red
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
        color
            |> Util.toHexColor
            |> String.dropLeft 1
    , gradientClickedOn = Nothing
    }


initWindow : Bool -> Window
initWindow show =
    { position = { x = 50, y = 350 }
    , clickState = Nothing
    , focusedOn = False
    , show = show
    }



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions { window } =
    if window.show && window.clickState /= Nothing then
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


integratePicker : Model -> Picker -> Model
integratePicker model picker =
    { model | picker = picker }


integrateWindow : Model -> Window -> Model
integrateWindow model window =
    { model | window = window }


updatePicker : PickerMsg -> Picker -> ( Picker, Reply )
updatePicker msg picker =
    case msg of
        SetFocus True ->
            picker & StealFocus

        SetFocus False ->
            picker & ReturnFocus

        UpdateColorHexField hex ->
            let
                newHexField =
                    String.toUpper hex
            in
            case toColor newHexField of
                Just color ->
                    { picker
                        | color = color
                        , colorHexField = newHexField
                    }
                        |> cohereAndSet

                Nothing ->
                    { picker
                        | colorHexField = newHexField
                    }
                        & NoReply

        StealSubmit ->
            picker & NoReply

        SetNoGradientClickedOn ->
            { picker
                | gradientClickedOn = Nothing
            }
                & NoReply

        MouseDownOnPointer gradient ->
            { picker
                | gradientClickedOn = Just gradient
            }
                & UpdateHistory picker.index picker.color

        MouseMoveInGradient gradient { targetPos, clientPos } ->
            let
                x =
                    (clientPos.x - targetPos.x - 4)
                        |> min 255
                        |> max 0
            in
            sliderHandler x gradient picker

        FieldUpdate gradient str ->
            fieldHandler gradient str picker


updateWindow : WindowMsg -> Window -> ( Window, Reply )
updateWindow msg window =
    case msg of
        HeaderMouseDown { targetPos, clientPos } ->
            { window
                | clickState =
                    { x = clientPos.x - targetPos.x
                    , y = clientPos.y - targetPos.y
                    }
                        |> Just
            }
                & NoReply

        HeaderMouseMove position ->
            case window.clickState of
                Nothing ->
                    window & NoReply

                Just originalClick ->
                    { window
                        | position =
                            { x = position.x - originalClick.x
                            , y = position.y - originalClick.y
                            }
                    }
                        & NoReply

        HeaderMouseUp ->
            { window | clickState = Nothing }
                & NoReply

        Close ->
            { window | show = False } & NoReply


update : Msg -> Model -> ( Model, Reply )
update message model =
    case message of
        HandlePickerMsg pickerMsg ->
            model.picker
                |> updatePicker pickerMsg
                |> Tuple.mapFirst (integratePicker model)

        HandleWindowMsg windowMsg ->
            model.window
                |> updateWindow windowMsg
                |> Tuple.mapFirst (integrateWindow model)



-- MESSAGE HANDLERS --


fieldHandler : Gradient -> String -> Picker -> ( Picker, Reply )
fieldHandler gradient str picker =
    case String.toInt str of
        Ok int ->
            fieldHandlerOk gradient str int picker

        Err _ ->
            fieldHandlerErr gradient str picker


fieldHandlerOk : Gradient -> String -> Int -> Picker -> ( Picker, Reply )
fieldHandlerOk gradient str int picker =
    let
        { hue, saturation, lightness } =
            Color.toHsl picker.color

        { red, green, blue } =
            Color.toRgb picker.color
    in
    case gradient of
        Lightness ->
            { picker
                | lightnessField = str
                , color =
                    Color.hsl
                        hue
                        saturation
                        (toFloat int / 255)
            }
                |> cohereAndSet

        Saturation ->
            { picker
                | saturationField = str
                , color =
                    Color.hsl
                        hue
                        (toFloat int / 255)
                        lightness
            }
                |> cohereAndSet

        Hue ->
            { picker
                | hueField = str
                , color =
                    Color.hsl
                        (degrees (toFloat int))
                        saturation
                        lightness
            }
                |> cohereAndSet

        Blue ->
            { picker
                | blueField = str
                , color =
                    validateHue
                        picker.color
                        (Color.rgb red green int)
                        int
            }
                |> cohereAndSet

        Green ->
            { picker
                | greenField = str
                , color =
                    validateHue
                        picker.color
                        (Color.rgb red int blue)
                        int
            }
                |> cohereAndSet

        Red ->
            { picker
                | redField = str
                , color =
                    validateHue
                        picker.color
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


fieldHandlerErr : Gradient -> String -> Picker -> ( Picker, Reply )
fieldHandlerErr gradient str picker =
    case gradient of
        Lightness ->
            { picker | lightnessField = str } & NoReply

        Saturation ->
            { picker | saturationField = str } & NoReply

        Hue ->
            { picker | hueField = str } & NoReply

        Blue ->
            { picker | blueField = str } & NoReply

        Green ->
            { picker | greenField = str } & NoReply

        Red ->
            { picker | redField = str } & NoReply


sliderHandler : Int -> Gradient -> Picker -> ( Picker, Reply )
sliderHandler x gradient picker =
    case gradient of
        Lightness ->
            let
                { hue, saturation } =
                    Color.toHsl picker.color
            in
            { picker
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
                    Color.toHsl picker.color
            in
            { picker
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
                    Color.toHsl picker.color
            in
            { picker
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
                    Color.toRgb picker.color
            in
            { picker
                | color = Color.rgb x green blue
            }
                |> cohereAndSet

        Green ->
            let
                { red, blue } =
                    Color.toRgb picker.color
            in
            { picker
                | color = Color.rgb red x blue
            }
                |> cohereAndSet

        Blue ->
            let
                { red, green } =
                    Color.toRgb picker.color
            in
            { picker
                | color = Color.rgb red green x
            }
                |> cohereAndSet



-- INTERNAL HELPERS --


cohereAndSet : Picker -> ( Picker, Reply )
cohereAndSet =
    cohereModel >> setColor


setColor : Picker -> ( Picker, Reply )
setColor ({ index, color } as picker) =
    picker & SetColor index color


cohereModel : Picker -> Picker
cohereModel picker =
    let
        { red, green, blue } =
            Color.toRgb picker.color

        { hue, saturation, lightness } =
            Color.toHsl picker.color
    in
    { picker
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
            picker.color
                |> Util.toHexColor
                |> String.dropLeft 1
    }



-- STYLES --


type Class
    = ColorPicker
    | Header
    | Body
    | Break
    | Visualization
    | SliderContainer
    | Gradient
    | Pointer
    | Transparent


css : Stylesheet
css =
    [ Css.class ColorPicker
        [ width (px 323)
        , height (px 223)
        , position absolute
        ]
    , (Css.class Visualization << List.append indent)
        [ height (px 20)
        , width (px 241)
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
        [ pointerEvents none ]
    ]
        |> namespace colorPickerNamespace
        |> stylesheet


colorPickerNamespace : String
colorPickerNamespace =
    "ColorPicker"



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
        [ header
            { text = "color picker"
            , headerMouseDown = HeaderMouseDown
            , xClick = Close
            }
            |> Html.map HandleWindowMsg
        , cardBody [] (body model.picker)
            |> Html.map HandlePickerMsg
        ]



-- BODY --


body : Picker -> List (Html PickerMsg)
body ({ colorHexField, color } as model) =
    [ div
        [ class [ Visualization ]
        , style
            [ "background" := Util.toHexColor color ]
        ]
        []
    , form
        [ onSubmit StealSubmit ]
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


slider : String -> String -> Gradient -> Html PickerMsg -> Html PickerMsg
slider label fieldContent gradient sliderGradient =
    div
        [ class [ SliderContainer ] ]
        [ p [] [ Html.text label ]
        , sliderGradient
        , input
            [ onInput (FieldUpdate gradient)
            , value fieldContent
            , onFocus (SetFocus True)
            , onBlur (SetFocus False)
            ]
            []
        ]



-- SLIDERS --


redGradient : Picker -> Html PickerMsg
redGradient { color, gradientClickedOn } =
    let
        { red, green, blue } =
            Color.toRgb color

        attributes : List (Attribute PickerMsg)
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


greenGradient : Picker -> Html PickerMsg
greenGradient { color, gradientClickedOn } =
    let
        { red, green, blue } =
            Color.toRgb color

        attributes : List (Attribute PickerMsg)
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


blueGradient : Picker -> Html PickerMsg
blueGradient { color, gradientClickedOn } =
    let
        { red, green, blue } =
            Color.toRgb color

        attributes : List (Attribute PickerMsg)
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


hueGradient : Picker -> Html PickerMsg
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

        attributes : List (Attribute PickerMsg)
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


saturationGradient : Picker -> Html PickerMsg
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

        attributes : List (Attribute PickerMsg)
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


lightnessGradient : Picker -> Html PickerMsg
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

        attributes : List (Attribute PickerMsg)
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


gradientAttributes : ( String, String ) -> List (Attribute PickerMsg)
gradientAttributes gradientStyle_ =
    [ class [ Gradient ]
    , style [ gradientStyle_ ]
    , Html.Events.onMouseUp SetNoGradientClickedOn
    ]


addMouseMoveHandler : List (Attribute PickerMsg) -> Maybe Gradient -> Gradient -> List (Attribute PickerMsg)
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
