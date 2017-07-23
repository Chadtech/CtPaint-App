module ColorPicker.Types exposing (..)

import Mouse exposing (Position)
import Color exposing (Color)
import MouseEvents exposing (MouseEvent)
import Array exposing (Array)
import Palette.Types as Palette
import MouseEvents exposing (MouseEvent)


type ExternalMessage
    = SetColor Int Color
    | SetFocus Bool


type Message
    = HeaderMouseDown MouseEvent
    | HeaderMouseMove Position
    | HeaderMouseUp Position
    | WakeUp Color Int
    | Close
    | SetColorScale ColorScale
    | HandleFocus Bool
    | StealSubmit
    | RedFieldUpdate String
    | GreenFieldUpdate String
    | BlueFieldUpdate String
    | HueFieldUpdate String
    | SaturationFieldUpdate String
    | LightnessFieldUpdate String
    | UpdateColorHexField String
    | MouseDownOnPointer Gradient
    | MouseMoveInGradient Gradient MouseEvent


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
    , redPointer : Maybe Position
    , greenPointer : Maybe Position
    , bluePointer : Maybe Position
    , huePointer : Maybe Position
    , saturationPointer : Maybe Position
    , lightnessPointer : Maybe Position
    , colorScale : ColorScale
    , show : Bool
    , colorHexField : String
    }


type ColorScale
    = Abs
    | Rel


init : Array Color -> Model
init colors =
    let
        color =
            case Array.get 0 colors of
                Just color ->
                    color

                Nothing ->
                    Color.black

        { red, green, blue } =
            Color.toRgb color

        { hue, saturation, lightness } =
            Color.toHsl color
    in
        { position = Position 50 350
        , clickState = Nothing
        , color = color
        , index = 0
        , redField = toString red
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
        , redPointer = Nothing
        , greenPointer = Nothing
        , bluePointer = Nothing
        , huePointer = Nothing
        , saturationPointer = Nothing
        , lightnessPointer = Nothing
        , colorScale = Abs
        , show = True
        , colorHexField =
            String.dropLeft 1 (Palette.toHex color)
        }
