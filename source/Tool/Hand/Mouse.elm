module Tool.Hand.Mouse exposing (..)

import Html exposing (Attribute)
import ElementRelativeMouseEvents as Events
import Tool.Hand.Types exposing (Message(..))
import Mouse


attributes : List (Attribute Message)
attributes =
    [ Events.onMouseDown OnScreenMouseDown ]


subs : List (Sub Message)
subs =
    [ Mouse.moves OnScreenMouseMove
    , Mouse.ups (always OnScreenMouseUp)
    ]
