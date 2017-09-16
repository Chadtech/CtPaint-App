module Menu.Text.Types exposing (..)

import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Window exposing (Size)


type Msg
    = UpdateField String
    | CloseClick
    | Finished
    | HeaderMouseDown MouseEvent
    | HeaderMouseMove Position
    | HeaderMouseUp


type ExternalMsg
    = DoNothing
    | AddText
    | Close


type alias Model =
    { text : String
    , position : Position
    , clickState : Maybe Position
    }


init : Size -> Model
init size =
    { text = ""
    , position =
        { x = (size.width // 2) - 208
        , y = (size.height // 2) - 50
        }
    , clickState = Nothing
    }
