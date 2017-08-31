module Minimap.Types exposing (..)

import Mouse exposing (Position)
import Window exposing (Size)
import MouseEvents exposing (MouseEvent)


type alias Model =
    { externalPosition : Position
    , internalPosition : Position
    , size : Size
    , zoom : Int
    , clickState : Maybe Position
    }


type ExternalMessage
    = Close
    | DoNothing


type Message
    = HeaderMouseDown MouseEvent
    | HeaderMouseMove Position
    | HeaderMouseUp
    | CloseClick


init : Size -> Model
init { width } =
    { externalPosition =
        { x = width - 400
        , y = 400
        }
    , internalPosition =
        { x = 0
        , y = 0
        }
    , size =
        { width = 250
        , height = 250
        }
    , zoom = 1
    , clickState = Nothing
    }
