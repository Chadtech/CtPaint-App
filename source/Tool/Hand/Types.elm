module Tool.Hand.Types exposing (Message(..))

import ElementRelativeMouseEvents exposing (Point)
import Mouse exposing (Position)


type Message
    = OnScreenMouseDown Point
    | OnScreenMouseMove Position
    | OnScreenMouseUp
