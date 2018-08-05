module Clipboard.Model
    exposing
        ( Model
        )

import Canvas exposing (Canvas)
import Data.Position as Position
    exposing
        ( Position
        )


type alias Model =
    { position : Position
    , canvas : Canvas
    }
