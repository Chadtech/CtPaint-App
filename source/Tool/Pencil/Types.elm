module Tool.Pencil.Types exposing (..)

import ElementRelativeMouseEvents exposing (Point)
import Mouse exposing (Position)


type Message
    = OnScreenMouseDown Position
    | SubMouseMove Position
    | SubMouseUp
