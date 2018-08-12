module Tool.Hand.Model
    exposing
        ( Model
        )

import Position.Data exposing (Position)


type alias Model =
    { initialCanvasPosition : Position
    , mousePositionInWindow : Position
    }
