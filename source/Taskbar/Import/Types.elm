module Taskbar.Import.Types exposing (..)

import Mouse exposing (Position)
import Window exposing (Size)
import MouseEvents exposing (MouseEvent)
import Canvas exposing (Error, Canvas)


type Message
    = UpdateField String
    | CloseClick
    | AttemptLoad
    | ImageLoaded (Result Error Canvas)
    | HeaderMouseDown MouseEvent
    | HeaderMouseMove Position
    | HeaderMouseUp


type ExternalMessage
    = DoNothing
    | Close
    | LoadImage
    | IncorporateImage Canvas


type alias Model =
    { url : String
    , position : Position
    , clickState : Maybe Position
    }


init : Size -> Model
init { width, height } =
    { url = ""
    , position =
        { x = (width // 2) - 208
        , y = (height // 2) - 106
        }
    , clickState = Nothing
    }
