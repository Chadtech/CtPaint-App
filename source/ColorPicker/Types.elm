module ColorPicker.Types exposing (..)

import Mouse exposing (Position)
import Color exposing (Color)
import MouseEvents exposing (MouseEvent)
import Array exposing (Array)
import Palette.Types as Palette


type ExternalMessage
    = SetColor Int Color
    | SetFocus Bool


type Message
    = HeaderMouseDown MouseEvent
    | HeaderMouseMove Position
    | HeaderMouseUp Position
    | WakeUp Color Int
    | Close
    | SetColorFormat ColorFormat
    | SetColorScale ColorScale
    | HandleFocus Bool
    | UpdateColorHexField String
    | StealSubmit


type alias Model =
    { position : Position
    , clickState : Maybe Position
    , color : Color
    , index : Int
    , colorFormat : ColorFormat
    , colorScale : ColorScale
    , show : Bool
    , colorHexField : String
    }


type ColorFormat
    = Rgb
    | Hsl


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
    in
        { position = Position 50 350
        , clickState = Nothing
        , color = color
        , index = 0
        , colorFormat = Rgb
        , colorScale = Abs
        , show = True
        , colorHexField =
            String.dropLeft 1 (Palette.toHex color)
        }
