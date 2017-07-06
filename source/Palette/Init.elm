module Palette.Init exposing (..)

import Color exposing (Color)
import Palette.Types exposing (Swatches)


palette : List Color
palette =
    [ Color.white
    , Color.black
    ]


swatches : Swatches
swatches =
    { bottomLeft = Color.white
    , bottomRight = Color.black
    , topLeft = Color.rgba 176 166 154 255
    , topRight = Color.rgba 20 59 47 255
    }
