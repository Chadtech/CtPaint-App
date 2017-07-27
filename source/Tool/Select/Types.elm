module Tool.Select.Types exposing (..)

import Canvas exposing (Canvas)
import Mouse exposing (Position)
import Time exposing (Time)


type alias Model =
    { selection : Maybe ( Position, Canvas )
    , click : Maybe Position
    }


type ExternalMessage
    = DrawSelection Position Canvas


type Message
    = OnScreenMouseDown Position
    | SubMouseMove Position
    | SubMouseUp
    | Tick Time


init : Model
init =
    { selection = Nothing
    , click = Nothing
    }
