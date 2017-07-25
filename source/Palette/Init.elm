module Palette.Init exposing (..)

import Color exposing (Color)
import Palette.Types exposing (Swatches)
import Array exposing (Array)


palette : Array Color
palette =
    [ Color.rgba 176 166 154 255
    , Color.black
    , Color.white
    , Color.rgba 241 29 35 255
    ]
        |> Array.fromList


swatches : Swatches
swatches =
    { primary = Color.rgba 176 166 154 255
    , first = Color.black
    , second = Color.white
    , third = Color.rgba 241 29 35 255
    , keyIsDown = False
    }
