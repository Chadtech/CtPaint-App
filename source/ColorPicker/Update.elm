module ColorPicker.Update exposing (update)

import ColorPicker.Types exposing (..)
import Mouse exposing (Position)
import Palette.Types as Palette
import Color
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

        SetColorScale scale ->
            let
                newModel =
                    { model
                        | colorScale = scale
                    }
            in
                ( newModel, Nothing )

        HandleFocus focused ->
            ( model, Just (SetFocus focused) )

        UpdateColorHexField hex ->
            let
                newModel =
                    { model
                        | colorHexField = String.toUpper hex
                    }
            in
                setColorMaybe newModel

        StealSubmit ->
            ( model, Nothing )

        RedFieldUpdate red ->
            case ParseInt.parseInt red of
                Ok int ->
                    let
                        { green, blue } =
                            Color.toRgb model.color

                        newColor =
                            Color.rgb int green blue

                        newModel =
                            { model
                                | redField = red
                                , color = newColor
                            }
                    in
                        ( cohereModel newModel
                        , Just (SetColor model.index newColor)
                        )

                Err _ ->
                    let
                        newModel =
                            { model
                                | redField = red
                            }
                    in
                        ( newModel, Nothing )

        GreenFieldUpdate green ->
            case ParseInt.parseInt green of
                Ok int ->
                    let
                        { red, blue } =
                            Color.toRgb model.color

                        newColor =
                            Color.rgb red int blue

                        newModel =
                            { model
                                | greenField = green
                                , color = newColor
                            }
                    in
                        ( cohereModel newModel
                        , Just (SetColor model.index newColor)
                        )

                Err _ ->
                    let
                        newModel =
                            { model
                                | greenField = green
                            }
                    in
                        ( newModel, Nothing )

        BlueFieldUpdate blue ->
            case ParseInt.parseInt blue of
                Ok int ->
                    let
                        { red, green } =
                            Color.toRgb model.color

                        newColor =
                            Color.rgb red green int

                        newModel =
                            { model
                                | blueField = blue
                                , color = newColor
                            }
                    in
                        ( cohereModel newModel
                        , Just (SetColor model.index newColor)
                        )

                Err _ ->
                    let
                        newModel =
                            { model
                                | blueField = blue
                            }
                    in
                        ( newModel, Nothing )

        HueFieldUpdate hue ->
            case ParseInt.parseInt hue of
                Ok int ->
                    let
                        { saturation, lightness } =
                            Color.toHsl model.color

                        newColor =
                            Color.hsl
                                (degrees (toFloat int))
                                saturation
                                lightness

                        newModel =
                            { model
                                | hueField = hue
                                , color = newColor
                            }
                    in
                        ( cohereModel newModel
                        , Just (SetColor model.index newColor)
                        )

                Err _ ->
                    let
                        newModel =
                            { model
                                | hueField = hue
                            }
                    in
                        ( newModel, Nothing )

        SaturationFieldUpdate saturation ->
            case ParseInt.parseInt saturation of
                Ok int ->
                    let
                        { hue, lightness } =
                            Color.toHsl model.color

                        newColor =
                            Color.hsl
                                hue
                                ((toFloat int) / 255)
                                lightness

                        newModel =
                            { model
                                | saturationField = saturation
                                , color = newColor
                            }
                    in
                        ( cohereModel newModel
                        , Just (SetColor model.index newColor)
                        )

                Err _ ->
                    let
                        newModel =
                            { model
                                | saturationField = saturation
                            }
                    in
                        ( newModel, Nothing )

        LightnessFieldUpdate lightness ->
            case ParseInt.parseInt lightness of
                Ok int ->
                    let
                        { hue, saturation } =
                            Color.toHsl model.color

                        newColor =
                            Color.hsl
                                hue
                                saturation
                                ((toFloat int) / 255)

                        newModel =
                            { model
                                | lightnessField = lightness
                                , color = newColor
                            }
                    in
                        ( cohereModel newModel
                        , Just (SetColor model.index newColor)
                        )

                Err _ ->
                    let
                        newModel =
                            { model
                                | lightnessField = lightness
                            }
                    in
                        ( newModel, Nothing )

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
                ( newModel, Nothing )

        MouseMoveInGradient gradient { targetPos, clientPos } ->
            let
                x =
                    (clientPos.x - targetPos.x - 4)
                        |> min 255
                        |> max 0
            in
                case model.gradientClickedOn of
                    Just Lightness ->
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
                            ( cohereModel newModel, Nothing )

                    Just Saturation ->
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
                            ( cohereModel newModel, Nothing )

                    Just Hue ->
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
                            ( cohereModel newModel, Nothing )

                    Just Red ->
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
                            ( cohereModel newModel, Nothing )

                    Just Green ->
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
                            ( cohereModel newModel, Nothing )

                    Just Blue ->
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
                            ( cohereModel newModel, Nothing )

                    Nothing ->
                        ( model, Nothing )



-- INTERNAL HELPERS --


setColorMaybe : Model -> ( Model, Maybe ExternalMessage )
setColorMaybe model =
    case Palette.toColor model.colorHexField of
        Just color ->
            let
                newModel =
                    { model
                        | color = color
                    }
            in
                ( cohereModel newModel
                , Just (SetColor model.index color)
                )

        Nothing ->
            ( model, Nothing )


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
