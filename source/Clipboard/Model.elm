module Clipboard.Model
    exposing
        ( Model
        )

import Canvas exposing (Canvas)
import Position.Data as Position
    exposing
        ( Position
        )


type alias Model =
    { position : Position
    , canvas : Canvas
    }
