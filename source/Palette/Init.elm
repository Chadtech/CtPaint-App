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
    { primary = Color.rgba 176 166 154 255
    , first = Color.black
    , second = Color.white
    , third = Color.rgba 241 29 35 255
    , keyIsDown = False
    }
