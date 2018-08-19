module Tool.Pencil.Model
    exposing
        ( Model
        )

import Data.Position exposing (Position)
import Html.Mouse exposing (Button)


type alias Model =
    { mousePositionOnCanvas : Position
    , mouseButton : Button
    }
