module Tool.Rectangle.Mouse exposing (..)

import ElementRelativeMouseEvents as Events
import Html exposing (Attribute)
import Mouse
import Tool.Rectangle.Types exposing (Msg(..))
import Util exposing (toPosition)


attributes : List (Attribute Msg)
attributes =
    [ Events.onMouseDown
        (OnScreenMouseDown << toPosition)
    ]


subs : List (Sub Msg)
subs =
    [ Mouse.moves SubMouseMove
    , Mouse.ups SubMouseUp
    ]
