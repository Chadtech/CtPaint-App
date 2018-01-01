module Data.Picker
    exposing
        ( ClickState(..)
        , Direction(..)
        , Fields
        , FieldsMsg(..)
        , Gradient(..)
        , Model
        , Msg(..)
        , Reply(..)
        , Window
        , WindowMsg(..)
        , init
        )

import Color exposing (Color)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Util


-- TYPES --


type Reply
    = NoReply
    | SetColor Int Color.Color
    | UpdateHistory Int Color.Color
    | StealFocus
    | ReturnFocus


type WindowMsg
    = HeaderMouseDown MouseEvent
    | HeaderMouseMove Position
    | HeaderMouseUp
    | XButtonMouseDown
    | XButtonMouseUp


type FieldsMsg
    = SetFocus Bool
    | StealSubmit
    | UpdateColorHexField String
    | MouseDownOnPointer Gradient
    | SetNoGradientClickedOn
    | MouseMoveInGradient Gradient MouseEvent
    | FieldUpdate Gradient String
    | ArrowClicked Gradient Direction


type Direction
    = Left
    | Right


type Msg
    = HandleFieldsMsg FieldsMsg
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
    , fields : Fields
    }


type alias Window =
    { position : Position
    , clickState : ClickState
    , focusedOn : Bool
    , show : Bool
    }


type ClickState
    = NoClicks
    | ClickAt Position
    | XButtonIsDown


type alias Fields =
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
    { fields = initFields index color
    , window = initWindow show
    }


initFields : Int -> Color.Color -> Fields
initFields index color =
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
    , clickState = NoClicks
    , focusedOn = False
    , show = show
    }
