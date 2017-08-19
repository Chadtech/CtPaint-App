module Tool.Line.Types exposing (..)

import Mouse exposing (Position)


type Message
    = OnScreenMouseDown Position
    | SubMouseMove Position
    | SubMouseUp Position
