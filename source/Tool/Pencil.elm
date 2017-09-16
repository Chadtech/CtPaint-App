module Tool.Pencil exposing (..)

import Html exposing (Attribute)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent, onMouseDown)


-- MESSAGE --


type Msg
    = ScreenMouseDown MouseEvent
    | SubMouseMove Position
    | SubMouseUp



-- ATTRIBUTES--


attributes : List (Attribute Msg)
attributes =
    [ onMouseDown ScreenMouseDown ]



-- SUBSCRIPTIONS --


subs : Sub Msg
subs =
    [ Mouse.moves SubMouseMove
    , Mouse.ups (always SubMouseUp)
    ]
        |> Sub.batch
