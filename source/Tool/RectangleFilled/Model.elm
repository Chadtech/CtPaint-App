module Tool.RectangleFilled.Model
    exposing
        ( Model
        )

import Data.Position exposing (Position)
import Html.Mouse exposing (Button)


type alias Model =
    { initialClickPositionOnCanvas : Position
    , mouseButton : Button
    }
