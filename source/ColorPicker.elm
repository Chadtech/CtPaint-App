module ColorPicker exposing (..)

import Array exposing (Array)
import Color exposing (Color)
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
import Html.Events
    exposing
        ( onBlur
        , onClick
        , onFocus
        , onInput
        , onSubmit
        )
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Util
    exposing
        ( (&)
        , (:=)
        , left
        , toColor
        , toHex
        , top
        )


-- TYPES --


type ExternalMsg
    = DoNothing
    | SetColor Int Color
    | UpdateHistory Int Color
    | StealFocus
    | ReturnFocus


type Msg
    = HeaderMouseDown MouseEvent
    | HeaderMouseMove Position
    | HeaderMouseUp Position
    | Close
    | SetFocus Bool
    | StealSubmit
    | UpdateColorHexField String
    | MouseDownOnPointer Gradient
    | SetNoGradientClickedOn
    | MouseMoveInGradient Gradient MouseEvent
    | FieldUpdate Gradient String


type Gradient
    = Red
    | Green
    | Blue
    | Hue
    | Saturation
    | Lightness


type alias Model =
    { position : Position
    , clickState : Maybe Position
    , color : Color
    , index : Int
    , redField : String
    , greenField : String
    , blueField : String
    , hueField : String
    , saturationField : String
    , lightnessField : String
    , show : Bool
    , colorHexField : String
    , gradientClickedOn : Maybe Gradient
    , focusedOn : Bool
    }



-- INIT --


init : Bool -> Int -> Color -> Model
init show index color =
    let
        { red, green, blue } =
            Color.toRgb color

        { hue, saturation, lightness } =
            Color.toHsl color
    in
    { position = Position 50 350
    , clickState = Nothing
    , color = color
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
    , show = show
    , colorHexField =
        String.dropLeft 1 (toHex color)
    , gradientClickedOn = Nothing
    , focusedOn = False
    }



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.show && model.clickState /= Nothing then
        Sub.batch
            [ Mouse.moves HeaderMouseMove
            , Mouse.ups HeaderMouseUp
            ]
    else
        Sub.none



-- UTIL --


doesntHaveHue : Color -> Bool
doesntHaveHue color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
    Util.allTrue
        [ red == green
        , green == blue
        , blue == red
        ]



-- UPDATE --


update : Msg -> Model -> ( Model, ExternalMsg )
update message model =
    case message of
        HeaderMouseDown { targetPos, clientPos } ->
            { model
                | clickState =
                    { x = clientPos.x - targetPos.x
                    , y = clientPos.y - targetPos.y
                    }
                        |> Just
            }
                & DoNothing

        HeaderMouseMove position ->
            case model.clickState of
                Nothing ->
                    model & DoNothing

                Just originalClick ->
                    { model
                        | position =
                            { x = position.x - originalClick.x
                            , y = position.y - originalClick.y
                            }
                    }
                        & DoNothing

        HeaderMouseUp _ ->
            { model | clickState = Nothing }
                & DoNothing

        Close ->
            { model | show = False } & DoNothing

        SetFocus True ->
            model & StealFocus

        SetFocus False ->
            model & ReturnFocus

        UpdateColorHexField hex ->
            let
                newHexField =
                    String.toUpper hex
            in
            case toColor newHexField of
                Just color ->
                    cohereAndSet
                        { model
                            | color = color
                            , colorHexField = newHexField
                        }

                Nothing ->
                    { model
                        | colorHexField = newHexField
                    }
                        & DoNothing

        StealSubmit ->
            model & DoNothing

        SetNoGradientClickedOn ->
            { model
                | gradientClickedOn = Nothing
            }
                & DoNothing

        MouseDownOnPointer gradient ->
            { model
                | gradientClickedOn = Just gradient
            }
                & UpdateHistory model.index model.color

        MouseMoveInGradient gradient { targetPos, clientPos } ->
            let
                x =
                    (clientPos.x - targetPos.x - 4)
                        |> min 255
                        |> max 0
            in
            sliderHandler x gradient model

        FieldUpdate gradient str ->
            fieldHandler gradient str model



-- MESSAGE HANDLERS --


fieldHandler : Gradient -> String -> Model -> ( Model, ExternalMsg )
fieldHandler gradient str model =
    case String.toInt str of
        Ok int ->
            fieldHandlerOk gradient str int model

        Err _ ->
            fieldHandlerErr gradient str model


fieldHandlerOk : Gradient -> String -> Int -> Model -> ( Model, ExternalMsg )
fieldHandlerOk gradient str int model =
    let
        { hue, saturation, lightness } =
            Color.toHsl model.color

        { red, green, blue } =
            Color.toRgb model.color
    in
    case gradient of
        Lightness ->
            cohereAndSet
                { model
                    | lightnessField = str
                    , color =
                        Color.hsl
                            hue
                            saturation
                            (toFloat int / 255)
                }

        Saturation ->
            cohereAndSet
                { model
                    | saturationField = str
                    , color =
                        Color.hsl
                            hue
                            (toFloat int / 255)
                            lightness
                }

        Hue ->
            cohereAndSet
                { model
                    | hueField = str
                    , color =
                        Color.hsl
                            (degrees (toFloat int))
                            saturation
                            lightness
                }

        Blue ->
            cohereAndSet
                { model
                    | blueField = str
                    , color =
                        validateHue
                            model.color
                            (Color.rgb red green int)
                            int
                }

        Green ->
            cohereAndSet
                { model
                    | greenField = str
                    , color =
                        validateHue
                            model.color
                            (Color.rgb red int blue)
                            int
                }

        Red ->
            cohereAndSet
                { model
                    | redField = str
                    , color =
                        validateHue
                            model.color
                            (Color.rgb int green blue)
                            int
                }


validateHue : Color -> Color -> Int -> Color
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


fieldHandlerErr : Gradient -> String -> Model -> ( Model, ExternalMsg )
fieldHandlerErr gradient str model =
    case gradient of
        Lightness ->
            { model | lightnessField = str } & DoNothing

        Saturation ->
            { model | saturationField = str } & DoNothing

        Hue ->
            { model | hueField = str } & DoNothing

        Blue ->
            { model | blueField = str } & DoNothing

        Green ->
            { model | greenField = str } & DoNothing

        Red ->
            { model | redField = str } & DoNothing


sliderHandler : Int -> Gradient -> Model -> ( Model, ExternalMsg )
sliderHandler x gradient model =
    case gradient of
        Lightness ->
            let
                { hue, saturation } =
                    Color.toHsl model.color

                newColor =
                    Color.hsl
                        hue
                        saturation
                        (toFloat x / 255)

                newModel =
                    { model
                        | color = newColor
                    }
            in
            cohereAndSet newModel

        Saturation ->
            let
                { hue, lightness } =
                    Color.toHsl model.color

                newColor =
                    Color.hsl
                        hue
                        (toFloat x / 255)
                        lightness

                newModel =
                    { model
                        | color = newColor
                    }
            in
            cohereAndSet newModel

        Hue ->
            let
                { saturation, lightness } =
                    Color.toHsl model.color

                newColor =
                    Color.hsl
                        (degrees ((toFloat x / 255) * 360))
                        saturation
                        lightness

                newModel =
                    { model
                        | color = newColor
                    }
            in
            cohereAndSet newModel

        Red ->
            let
                { green, blue } =
                    Color.toRgb model.color

                newColor =
                    Color.rgb
                        x
                        green
                        blue

                newModel =
                    { model
                        | color = newColor
                    }
            in
            cohereAndSet newModel

        Green ->
            let
                { red, blue } =
                    Color.toRgb model.color

                newColor =
                    Color.rgb
                        red
                        x
                        blue

                newModel =
                    { model
                        | color = newColor
                    }
            in
            cohereAndSet newModel

        Blue ->
            let
                { red, green } =
                    Color.toRgb model.color

                newColor =
                    Color.rgb
                        red
                        green
                        x

                newModel =
                    { model
                        | color = newColor
                    }
            in
            cohereAndSet newModel



-- INTERNAL HELPERS --


cohereAndSet : Model -> ( Model, ExternalMsg )
cohereAndSet =
    cohereModel >> setColor


setColor : Model -> ( Model, ExternalMsg )
setColor ({ index, color } as model) =
    model & SetColor index color


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
            String.dropLeft 1 (toHex model.color)
    }



-- VIEW --


view : Model -> Html Msg
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
            , MouseEvents.onMouseDown HeaderMouseDown
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


body : Model -> List (Html Msg)
body ({ colorHexField, color } as model) =
    [ div
        [ class "visualization"
        , style
            [ "background" := toHex color ]
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


slider : String -> String -> Gradient -> Html Msg -> Html Msg
slider label fieldContent gradient sliderGradient =
    div
        [ class "slider-container" ]
        [ p [] [ text label ]
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


redGradient : Model -> Html Msg
redGradient { color, gradientClickedOn } =
    let
        { red, green, blue } =
            Color.toRgb color

        attributes : List (Attribute Msg)
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
            , style [ left (red - 2) ]
            , Html.Events.onMouseDown (MouseDownOnPointer Red)
            ]
            []
        ]


greenGradient : Model -> Html Msg
greenGradient { color, gradientClickedOn } =
    let
        { red, green, blue } =
            Color.toRgb color

        attributes : List (Attribute Msg)
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
            , style [ left (green - 2) ]
            , Html.Events.onMouseDown (MouseDownOnPointer Green)
            ]
            []
        ]


blueGradient : Model -> Html Msg
blueGradient { color, gradientClickedOn } =
    let
        { red, green, blue } =
            Color.toRgb color

        attributes : List (Attribute Msg)
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
            , style [ left (blue - 2) ]
            , Html.Events.onMouseDown (MouseDownOnPointer Blue)
            ]
            []
        ]


hueGradient : Model -> Html Msg
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

        attributes : List (Attribute Msg)
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
                [ left (floor ((hue / (2 * pi)) * 255)) ]
            , Html.Events.onMouseDown (MouseDownOnPointer Hue)
            ]
            []
        ]


saturationGradient : Model -> Html Msg
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

        attributes : List (Attribute Msg)
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
                [ left (floor (saturation * 255) - 2) ]
            , Html.Events.onMouseDown (MouseDownOnPointer Saturation)
            ]
            []
        ]


lightnessGradient : Model -> Html Msg
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

        attributes : List (Attribute Msg)
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
                [ left (floor (lightness * 255) - 2) ]
            , Html.Events.onMouseDown (MouseDownOnPointer Lightness)
            ]
            []
        ]



-- INTERNAL HELPERS --


gradientAttributes : ( String, String ) -> List (Attribute Msg)
gradientAttributes gradientStyle_ =
    [ class "gradient"
    , style [ gradientStyle_ ]
    , Html.Events.onMouseUp SetNoGradientClickedOn
    ]


addMouseMoveHandler : List (Attribute Msg) -> Maybe Gradient -> Gradient -> List (Attribute Msg)
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
