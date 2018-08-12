module Tool.Line.Model
    exposing
        ( Model
        )

import Position.Data exposing (Position)
import Mouse.Extra exposing (Button)


type alias Model =
    { initialClickPositionOnCanvas : Position
    , mouseButton : Button
    }
