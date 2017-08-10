module Tool.Sample.Mouse exposing (..)

import Html exposing (Attribute)
import Tool.Sample.Types exposing (Message(..))
import Mouse


attributes : List (Attribute Message)
attributes =
    []


subs : List (Sub Message)
subs =
    [ Mouse.ups SubMouseUp ]
