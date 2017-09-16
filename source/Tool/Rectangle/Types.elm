module Tool.Rectangle.Types exposing (..)

import Mouse exposing (Position)


type Msg
    = OnScreenMouseDown Position
    | SubMouseMove Position
    | SubMouseUp Position
