module Color.Picker.Update
    exposing
        ( update
        )

import Color exposing (Color)
import Color.Model as Model exposing (Model)
import Color.Picker.Data as Picker exposing (Picker)
import Color.Picker.Data.Gradient as Gradient
    exposing
        ( Gradient
        )
import Color.Picker.Msg
    exposing
        ( Direction(Left, Right)
        , Msg(..)
        )
import Color.Reply exposing (Reply(UpdateColorHistory))
import Color.Util
import Data.Position as Position
import MouseEvents exposing (MouseEvent)
import Ports
import Return2 as R2
import Return3 as R3 exposing (Return)
import Util


update : Msg -> Model -> Return Model Msg Reply
update msg ({ picker } as model) =
    case msg of
        HeaderMouseDown mouseEvent ->
            case model.picker.headerClickState of
                Picker.XButtonIsDown ->
                    model
                        |> R3.withNothing

                _ ->
                    mouseEvent
                        |> Position.relativeToTarget
                        |> Picker.ClickAt
                        |> Picker.setHeaderClickState
                        |> Model.mapPicker
                        |> Model.applyTo model
                        |> R3.withNothing

        XButtonMouseDown ->
            Picker.XButtonIsDown
                |> Picker.setHeaderClickState
                |> Model.mapPicker
                |> Model.applyTo model
                |> R3.withNothing

        XButtonMouseUp ->
            model
                |> Model.mapPicker Picker.close
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
                newHexField : String
                newHexField =
                    String.toUpper hex

                hexFieldUpdatedModel : Model
                hexFieldUpdatedModel =
                    newHexField
                        |> Picker.setHexField
                        |> Model.mapPicker
                        |> Model.applyTo model
            in
            case Color.Util.fromString newHexField of
                Just color ->
                    newHexField
                        |> Picker.setHexField
                        |> Model.mapPicker
                        |> Model.applyTo model
                        |> Model.setPickersColor color
                        |> Model.syncPickersFields
                        |> R3.withNothing

                Nothing ->
                    newHexField
                        |> Picker.setHexField
                        |> Model.mapPicker
                        |> Model.applyTo model
                        |> R3.withNothing

        StealSubmit ->
            model |> R3.withNothing

        GradientMouseDown gradient event ->
            case Model.getPickersColor model of
                Just color ->
                    let
                        updatedColor =
                            updateColorFromMouseEvent
                                event
                                gradient
                                color
                    in
                    model
                        |> Model.setPickersColor updatedColor
                        |> Model.mapPicker (Picker.setGradientClickedOn gradient)
                        |> R3.withNothing

                Nothing ->
                    model
                        |> R3.withNothing

        MouseDownOnPointer gradient ->
            case Model.getPickersColor model of
                Just color ->
                    gradient
                        |> Picker.setGradientClickedOn
                        |> Model.mapPicker
                        |> Model.applyTo model
                        |> R2.withNoCmd
                        |> R3.withReply
                            (UpdateColorHistory picker.colorIndex color)

                Nothing ->
                    model
                        |> R3.withNothing

        MouseMoveInGradient gradient event ->
            if movedInCurrentGradient picker gradient then
                Model.mapPickersColor
                    (updateColorFromMouseEvent event gradient)
                    model
                    |> R3.withNothing
            else
                model
                    |> R3.withNothing

        FieldUpdated gradient str ->
            updateColorFromString gradient str model
                |> R3.withNothing

        ArrowClicked gradient direction ->
            Model.mapPickersColor
                (updateColorFromClick gradient direction)
                model
                |> R3.withNothing

        ClientMouseUp ->
            { model
                | picker =
                    picker
                        |> Picker.setHeaderClickState Picker.NoClicks
                        |> Picker.removeGradientClickedOn
            }
                |> R3.withNothing

        ClientMouseMove position ->
            position
                |> getPosFromMouseMove picker
                |> Picker.setPosition
                |> Model.mapPicker
                |> Model.applyTo model
                |> R3.withNothing


movedInCurrentGradient : Picker -> Gradient -> Bool
movedInCurrentGradient { gradientClickedOn } gradient =
    gradientClickedOn
        |> Maybe.map ((==) gradient)
        |> Maybe.withDefault False


getPosFromMouseMove : Picker -> Position.Position -> Position.Position
getPosFromMouseMove picker position =
    case picker.headerClickState of
        Picker.NoClicks ->
            picker.position

        Picker.XButtonIsDown ->
            picker.position

        Picker.ClickAt originalClick ->
            { x = position.x - originalClick.x
            , y = position.y - originalClick.y
            }


updateColorFromClick : Gradient -> Direction -> Color -> Color
updateColorFromClick gradient direction color =
    let
        { hue, saturation, lightness } =
            Color.toHsl color

        { red, green, blue } =
            Color.toRgb color
    in
    case gradient of
        Gradient.Lightness ->
            let
                lightnessInt =
                    Basics.round (lightness * 255)
            in
            case direction of
                Left ->
                    if 0 < lightnessInt then
                        Color.hsl
                            hue
                            saturation
                            (toFloat (lightnessInt - 1) / 255)
                    else
                        color

                Right ->
                    if lightnessInt < 255 then
                        Color.hsl
                            hue
                            saturation
                            (toFloat (lightnessInt + 1) / 255)
                    else
                        color

        Gradient.Saturation ->
            let
                saturationInt =
                    Basics.round (saturation * 255)
            in
            case direction of
                Left ->
                    if 0 < saturationInt then
                        Color.hsl
                            hue
                            (toFloat (saturationInt - 1) / 255)
                            lightness
                    else
                        color

                Right ->
                    if saturationInt < 255 then
                        Color.hsl
                            hue
                            (toFloat (saturationInt + 1) / 255)
                            lightness
                    else
                        color

        Gradient.Hue ->
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
            Color.hsl
                newHue
                saturation
                lightness

        Gradient.Red ->
            case direction of
                Left ->
                    if 0 < red then
                        Color.rgb
                            (red - 1)
                            green
                            blue
                    else
                        color

                Right ->
                    if red < 255 then
                        Color.rgb
                            (red + 1)
                            green
                            blue
                    else
                        color

        Gradient.Green ->
            case direction of
                Left ->
                    if 0 < green then
                        Color.rgb
                            red
                            (green - 1)
                            blue
                    else
                        color

                Right ->
                    if green < 255 then
                        Color.rgb
                            red
                            (green + 1)
                            blue
                    else
                        color

        Gradient.Blue ->
            case direction of
                Left ->
                    if 0 < blue then
                        Color.rgb
                            red
                            green
                            (blue - 1)
                    else
                        color

                Right ->
                    if blue < 255 then
                        Color.rgb
                            red
                            green
                            (blue + 1)
                    else
                        color


updateColorFromString : Gradient -> String -> Model -> Model
updateColorFromString gradient str model =
    case String.toInt str of
        Ok int ->
            Model.mapPickersColor
                (updateColorFromInt int gradient)
                model

        Err _ ->
            str
                |> updateField gradient
                |> Picker.mapFields
                |> Model.mapPicker
                |> Model.applyTo model


validateHue : Int -> Color -> Color -> Color
validateHue x oldColor newColor =
    if Color.Util.doesntHaveHue newColor then
        let
            { hue, lightness } =
                Color.toHsl oldColor
        in
        Color.hsl
            hue
            (toFloat x / 255)
            lightness
    else
        newColor


updateField : Gradient -> String -> Picker.Fields -> Picker.Fields
updateField gradient str fields =
    case gradient of
        Gradient.Lightness ->
            { fields | lightness = str }

        Gradient.Saturation ->
            { fields | saturation = str }

        Gradient.Hue ->
            { fields | hue = str }

        Gradient.Blue ->
            { fields | blue = str }

        Gradient.Green ->
            { fields | green = str }

        Gradient.Red ->
            { fields | red = str }


updateColorFromMouseEvent : MouseEvent -> Gradient -> Color -> Color
updateColorFromMouseEvent { targetPos, clientPos } gradient color =
    let
        x : Int
        x =
            (clientPos.x - targetPos.x - 4)
                |> min 255
                |> max 0
    in
    updateColorFromInt x gradient color
        |> validateHue x color


updateColorFromInt : Int -> Gradient -> Color -> Color
updateColorFromInt x gradient color =
    case gradient of
        Gradient.Lightness ->
            let
                { hue, saturation } =
                    Color.toHsl color
            in
            Color.hsl
                hue
                saturation
                (toFloat x / 255)

        Gradient.Saturation ->
            let
                { hue, lightness } =
                    Color.toHsl color
            in
            Color.hsl
                (Util.filterNan hue)
                (toFloat x / 255)
                lightness

        Gradient.Hue ->
            let
                { saturation, lightness } =
                    Color.toHsl color
            in
            Color.hsl
                (degrees ((toFloat x / 255) * 360))
                saturation
                lightness

        Gradient.Red ->
            let
                { green, blue } =
                    Color.toRgb color
            in
            Color.rgb x green blue

        Gradient.Green ->
            let
                { red, blue } =
                    Color.toRgb color
            in
            Color.rgb red x blue

        Gradient.Blue ->
            let
                { red, green } =
                    Color.toRgb color
            in
            Color.rgb red green x
