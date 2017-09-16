module Tool.Hand exposing (..)

import Html exposing (Attribute)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)


type alias HandModel =
    Maybe ( Position, Position )


type Msg
    = ScreenMouseDown MouseEvent
    | SubMouseMove Position
    | SubMouseUp



-- ATTRIBUTES --


attributes : List (Attribute Msg)
attributes =
    [ MouseEvents.onMouseDown ScreenMouseDown ]



-- SUBS --


subs : Sub Msg
subs =
    [ Mouse.moves SubMouseMove
    , Mouse.ups (always SubMouseUp)
    ]
        |> Sub.batch
