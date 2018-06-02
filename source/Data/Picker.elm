module Data.Picker
    exposing
        ( ClickState(..)
        , Direction(..)
        , Gradient(..)
        , Model
        , Msg(..)
        , Reply(..)
        , init
        )

import Color exposing (Color)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Util


-- TYPES --


type Reply
    = SetColor Int Color
    | UpdateHistory Int Color


type Direction
    = Left
    | Right


type Msg
    = InputFocused
    | InputBlurred
    | StealSubmit
    | HexFieldUpdated String
    | MouseDownOnPointer Gradient
    | GradientMouseDown Gradient MouseEvent
    | MouseMoveInGradient Gradient MouseEvent
    | FieldUpdated Gradient String
    | ArrowClicked Gradient Direction
    | HeaderMouseDown MouseEvent
    | XButtonMouseDown
    | XButtonMouseUp
    | ClientMouseUp
    | ClientMouseMove Position


type Gradient
    = Red
    | Green
    | Blue
    | Hue
    | Saturation
    | Lightness


type alias Model =
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
    , position : Position
    , headerClickState : ClickState
    , focusedOn : Bool
    , show : Bool
    }


type ClickState
    = NoClicks
    | ClickAt Position
    | XButtonIsDown



-- INIT --


init : Bool -> Int -> Color.Color -> Model
init show index color =
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
    , position = { x = 50, y = 350 }
    , headerClickState = NoClicks
    , focusedOn = False
    , show = show
    }
