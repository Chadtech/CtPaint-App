module Tool.Select exposing (..)

import Html exposing (Attribute)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent, onMouseDown)
import Util exposing (toPosition)


-- TYPES --


type alias SelectModel =
    Maybe Position


type Msg
    = ScreenMouseDown MouseEvent
    | SubMouseMove Position
    | SubMouseUp Position



-- ATTRIBUTES --


attributes : List (Attribute Msg)
attributes =
    [ onMouseDown ScreenMouseDown ]



-- SUBSCRIPTIONS --


subs : Sub Msg
subs =
    [ Mouse.moves SubMouseMove
    , Mouse.ups SubMouseUp
    ]
        |> Sub.batch
