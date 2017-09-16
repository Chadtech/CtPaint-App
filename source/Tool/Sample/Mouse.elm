module Tool.Sample.Mouse exposing (..)

import Html exposing (Attribute)
import Mouse
import Tool.Sample.Types exposing (Msg(..))


attributes : List (Attribute Msg)
attributes =
    []


subs : List (Sub Msg)
subs =
    [ Mouse.ups SubMouseUp ]
