module Tool.Hand.Types exposing (Msg(..))

import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)


type Msg
    = ScreenMouseDown MouseEvent
    | SubMouseMove Position
    | SubMouseUp
