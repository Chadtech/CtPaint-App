module Tool.Hand.Mouse exposing (..)

import Html exposing (Attribute)
import Mouse
import MouseEvents
import Tool.Hand.Types exposing (Message(..))


attributes : List (Attribute Message)
attributes =
    [ MouseEvents.onMouseDown ScreenMouseDown ]


subs : List (Sub Message)
subs =
    [ Mouse.moves SubMouseMove
    , Mouse.ups (always SubMouseUp)
    ]
