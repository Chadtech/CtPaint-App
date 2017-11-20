module Data.History exposing (Event(..), Model)

import Canvas exposing (Canvas)
import Color exposing (Color)


type Event
    = CanvasChange Canvas
    | ColorChange Int Color


type alias Model =
    { past : List Event
    , future : List Event
    }
