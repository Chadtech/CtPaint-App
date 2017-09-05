module Tool.ZoomIn.Mouse exposing (..)

import ElementRelativeMouseEvents as Events
import Html exposing (Attribute)
import Tool.ZoomIn.Types exposing (Message(..))
import Util exposing (toPosition)


attributes : List (Attribute Message)
attributes =
    [ Events.onMouseUp
        (OnScreenMouseUp << toPosition)
    ]


subs : List (Sub Message)
subs =
    []
