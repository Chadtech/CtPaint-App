module Tool.Pencil.Mouse exposing (..)

import Html exposing (Attribute)
import ElementRelativeMouseEvents as Events
import Tool.Pencil.Types exposing (Message(..))
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
    , Mouse.ups (always SubMouseUp)
    ]
