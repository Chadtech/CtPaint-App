module Menu.Import.Types exposing (..)

import Canvas exposing (Canvas, Error)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Window exposing (Size)


type Msg
    = UpdateField String
    | CloseClick
    | AttemptLoad
    | ImageLoaded (Result Error Canvas)
    | TryAgain
    | HeaderMouseDown MouseEvent
    | HeaderMouseMove Position
    | HeaderMouseUp


type ExternalMsg
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
