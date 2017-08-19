module Tool.Fill.Mouse exposing (..)

import Html exposing (Attribute)
import Tool.Fill.Types exposing (Message(..))
import Mouse


attributes : List (Attribute Message)
attributes =
    []


subs : List (Sub Message)
subs =
    [ Mouse.ups SubMouseUp ]
