module Menu.Import.Types exposing (..)

import Canvas exposing (Canvas, Error)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Window exposing (Size)


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
    , error : Bool
    }


init : Size -> Model
init { width, height } =
    { url = ""
    , position =
        { x = (width // 2) - 208
        , y = (height // 2) - 106
        }
    , clickState = Nothing
    , error = False
    }
