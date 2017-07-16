module ColorPicker.Types exposing (..)

import Mouse exposing (Position)
import Color exposing (Color)


type ExternalMessage
    = SetColor Int Color


type Message
    = HeaderMouseDown Position
    | WakeUp Color Int
    | Close


type alias Model =
    { position : Position
    , color : Color
    , index : Int
    , colorFormat : ColorFormat
    , colorScale : ColorScale
    , show : Bool
    }


type ColorFormat
    = Rgb
    | Hsl


type ColorScale
    = Abs
    | Rel


init : Model
init =
    { position = Position 50 350
    , color = Color.black
    , index = 0
    , colorFormat = Rgb
    , colorScale = Abs
    , show = True
    }
