module Menu.Scale.Types exposing (..)

import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Window exposing (Size)


type alias Model =
    { position : Position
    , clickState : Maybe Position
    , fixedWidth : Int
    , fixedHeight : Int
    , percentWidth : Float
    , percentHeight : Float
    , initialSize : Size
    , lockRatio : Bool
    }


type ExternalMessage
    = DoNothing
    | Close
    | Finish


type Message
    = UpdateField Field String
    | CloseClick
    | OkayClick
    | HeaderMouseDown MouseEvent
    | HeaderMouseMove Position
    | HeaderMouseUp
    | SetSize


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
    , fixedWidth = windowSize.width
    , fixedHeight = windowSize.height
    , percentWidth = 100
    , percentHeight = 100
    , initialSize = canvasSize
    , lockRatio = False
    }
