module Tool.Hand.Types exposing (Message(..))

import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)


type Message
    = ScreenMouseDown MouseEvent
    | SubMouseMove Position
    | SubMouseUp
