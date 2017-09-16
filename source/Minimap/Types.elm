module Minimap.Types exposing (..)

import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Window exposing (Size)


type alias Model =
    { externalPosition : Position
    , internalPosition : Position
    , size : Size
    , zoom : Int
    , clickState : Maybe Position
    }


type ExternalMsg
    = Close
    | DoNothing


type Msg
    = HeaderMouseDown MouseEvent
    | HeaderMouseMove Position
    | HeaderMouseUp
    | CloseClick


init : Size -> Model
init { width, height } =
    let
        minimapSize =
            { width = 250 + extraWidth
            , height = 250 + extraHeight
            }
    in
    { externalPosition =
        { x = (width - minimapSize.width) // 2
        , y = (height - minimapSize.height) // 2
        }
    , internalPosition =
        { x = 0
        , y = 0
        }
    , size = minimapSize
    , zoom = 1
    , clickState = Nothing
    }


extraHeight : Int
extraHeight =
    64


extraWidth : Int
extraWidth =
    8
