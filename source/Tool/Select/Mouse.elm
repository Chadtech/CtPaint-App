module Tool.Select.Mouse exposing (..)

import Html exposing (Attribute)
import ElementRelativeMouseEvents as Events
import Tool.Select.Types exposing (Message(..))
import Util exposing (toPosition)
import Mouse


attributes : List (Attribute Message)
attributes =
    [ Events.onMouseDown
        (OnScreenMouseDown << toPosition)
    ]


subs : List (Sub Message)
subs =
    [ Mouse.moves SubMouseMove
    , Mouse.ups SubMouseUp
    ]
