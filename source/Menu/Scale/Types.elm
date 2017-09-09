module Menu.Scale.Types exposing (..)

import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Window exposing (Size)


type alias Model =
    { position : Position
    , clickState : Maybe Position
    , fixedWidthField : String
    , fixedHeightField : String
    , percentWidthField : String
    , percentHeightField : String
    }


type Message
    = UpdateField Field String
    | CloseClick
    | HeaderMouseDown MouseEvent
    | HeaderMouseMove Position
    | HeaderMouseUp


type Field
    = FixedWidth
    | FixedHeight
    | PercentWidth
    | PercentHeight


init : Size -> Size -> Model
init windowSize canvasSize =
    { position =
        { x = windowSize.width // 2
        , y = windowSize.height // 2
        }
    , clickState = Nothing
    , fixedWidthField = toString windowSize.width
    , fixedHeightField = toString windowSize.height
    , percentWidthField = "100"
    , percentHeightField = "100"
    }
