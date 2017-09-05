module Tool.Sample.Mouse exposing (..)

import Html exposing (Attribute)
import Mouse
import Tool.Sample.Types exposing (Message(..))


attributes : List (Attribute Message)
attributes =
    []


subs : List (Sub Message)
subs =
    [ Mouse.ups SubMouseUp ]
