module Tool.ZoomIn.Mouse exposing (..)

import ElementRelativeMouseEvents as Events
import Html exposing (Attribute)
import Tool.ZoomIn.Types exposing (Msg(..))
import Util exposing (toPosition)


attributes : List (Attribute Msg)
attributes =
    [ Events.onMouseUp
        (OnScreenMouseUp << toPosition)
    ]


subs : List (Sub Msg)
subs =
    []
