module Tool.Hand.Model
    exposing
        ( Model
        )

import Data.Position exposing (Position)


type alias Model =
    { initialCanvasPosition : Position
    , mousePositionInWindow : Position
    }
