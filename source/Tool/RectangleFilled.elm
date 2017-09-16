module Tool.RectangleFilled exposing (..)

import Html exposing (Attribute)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent, onMouseDown)


-- MESSAGE --


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
