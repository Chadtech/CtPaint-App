module Tool.Hand.Mouse exposing (..)

import Html exposing (Attribute)
import Mouse
import MouseEvents
import Tool.Hand.Types exposing (Msg(..))


attributes : List (Attribute Msg)
attributes =
    [ MouseEvents.onMouseDown ScreenMouseDown ]


subs : List (Sub Msg)
subs =
    [ Mouse.moves SubMouseMove
    , Mouse.ups (always SubMouseUp)
    ]
