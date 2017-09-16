module Tool.Fill.Mouse exposing (..)

import Html exposing (Attribute)
import MouseEvents exposing (onMouseUp)
import Tool.Fill.Types exposing (Msg(..))


attributes : List (Attribute Msg)
attributes =
    [ onMouseUp ScreenMouseUp ]


subs : List (Sub Msg)
subs =
    []
