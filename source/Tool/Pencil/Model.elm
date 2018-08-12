module Tool.Pencil.Model
    exposing
        ( Model
        )

import Position.Data exposing (Position)
import Mouse.Extra exposing (Button)


type alias Model =
    { mousePositionOnCanvas : Position
    , mouseButton : Button
    }
