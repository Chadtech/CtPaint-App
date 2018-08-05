module Tool.Pencil.Model
    exposing
        ( Model
        )

import Data.Position exposing (Position)
import Mouse.Extra exposing (Button)


type alias Model =
    { mousePositionOnCanvas : Position
    , mouseButton : Button
    }
