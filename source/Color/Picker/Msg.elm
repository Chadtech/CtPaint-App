module Color.Picker.Msg exposing
    ( Direction(..)
    , Msg(..)
    , directionToString
    )

import Color.Picker.Data.Gradient
    exposing
        ( Gradient
        )
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)


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


type Direction
    = Left
    | Right


directionToString : Direction -> String
directionToString direction =
    case direction of
        Left ->
            "left"

        Right ->
            "right"
