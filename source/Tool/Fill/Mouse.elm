module Tool.Fill.Mouse exposing (..)

import Html exposing (Attribute)
import MouseEvents exposing (onMouseUp)
import Tool.Fill.Types exposing (Message(..))


attributes : List (Attribute Message)
attributes =
    [ onMouseUp ScreenMouseUp ]


subs : List (Sub Message)
subs =
    []
