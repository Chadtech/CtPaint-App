module Data.Picker
    exposing
        ( ClickState(..)
        , Fields
        , FieldsMsg(..)
        , Gradient(..)
        , Model
        , Msg(..)
        , Reply(..)
        , Window
        , WindowMsg(..)
        )

import Color exposing (Color)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)


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
