module ColorPicker.Update exposing (update)

import ColorPicker.Types exposing (..)
import ColorPicker.Util exposing (doesntHaveHue)
import Mouse exposing (Position)
import Palette.Types as Palette
import Color exposing (Color)
import ParseInt


update : Message -> Model -> ( Model, Maybe ExternalMessage )
update message model =
    case message of
        HeaderMouseDown { targetPos, clientPos } ->
            let
                newModel =
                    { model
                        | clickState =
                            Position
                                (clientPos.x - targetPos.x)
                                (clientPos.y - targetPos.y)
                                |> Just
                    }
            in
                ( newModel, Nothing )

        HeaderMouseMove position ->
            case model.clickState of
                Nothing ->
                    ( model, Nothing )

                Just originalClick ->
                    let
                        x =
                            position.x - originalClick.x

                        y =
                            position.y - originalClick.y

                        newModel =
                            { model
                                | position =
                                    Position x y
                            }
                    in
                        ( newModel, Nothing )

        HeaderMouseUp _ ->
            let
                newModel =
                    { model
                        | clickState = Nothing
                    }
            in
                ( newModel, Nothing )

        WakeUp color index ->
            let
                newModel =
                    { model
                        | color = color
                        , index = index
                        , show = True
                    }
            in
                ( newModel, Nothing )

        Close ->
            let
                newModel =
                    { model
                        | show = False
                    }
            in
                ( newModel, Nothing )

        HandleFocus focused ->
            ( model, Just (SetFocus focused) )

        UpdateColorHexField hex ->
            let
                newHexField =
                    String.toUpper hex
            in
                case Palette.toColor newHexField of
                    Just color ->
                        let
                            newModel =
                                { model
                                    | color = color
                                    , colorHexField = newHexField
                                }
                        in
                            cohereAndSet newModel

                    Nothing ->
                        let
                            newModel =
                                { model
                                    | colorHexField = newHexField
                                }
                        in
                            ( newModel, Nothing )

        StealSubmit ->
            ( model, Nothing )

        SetNoGradientClickedOn ->
            let
                newModel =
                    { model
                        | gradientClickedOn = Nothing
                    }
            in
                ( newModel, Nothing )

        MouseDownOnPointer gradient ->
            let
                newModel =
                    { model
                        | gradientClickedOn = Just gradient
                    }
            in
                ( newModel
                , Just (UpdateHistory model.index model.color)
                )

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


fieldHandler : Gradient -> String -> Model -> ( Model, Maybe ExternalMessage )
fieldHandler gradient str model =
    case ParseInt.parseInt str of
        Ok int ->
            fieldHandlerOk gradient str int model

        Err _ ->
            fieldHandlerErr gradient str model


fieldHandlerOk : Gradient -> String -> Int -> Model -> ( Model, Maybe ExternalMessage )
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


fieldHandlerErr : Gradient -> String -> Model -> ( Model, Maybe ExternalMessage )
fieldHandlerErr gradient str model =
    case gradient of
        Lightness ->
            ( { model | lightnessField = str }, Nothing )

        Saturation ->
            ( { model | saturationField = str }, Nothing )

        Hue ->
            ( { model | hueField = str }, Nothing )

        Blue ->
            ( { model | blueField = str }, Nothing )

        Green ->
            ( { model | greenField = str }, Nothing )

        Red ->
            ( { model | redField = str }, Nothing )


sliderHandler : Int -> Gradient -> Model -> ( Model, Maybe ExternalMessage )
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


cohereAndSet : Model -> ( Model, Maybe ExternalMessage )
cohereAndSet =
    cohereModel >> setColor


setColor : Model -> ( Model, Maybe ExternalMessage )
setColor ({ index, color } as model) =
    ( model
    , Just (SetColor index color)
    )


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
                ((radians hue) / (2 * pi) * 360)
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
                String.dropLeft 1 (Palette.toHex model.color)
        }
