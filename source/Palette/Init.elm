module Palette.Init exposing (..)

import Color exposing (Color)
import Palette.Types exposing (Swatches)
import Array exposing (Array)


palette : Array Color
palette =
    [ Color.white
    , Color.black
    , Color.rgba 241 29 35 255
    , Color.rgba 120 175 211 255
    , Color.rgba 126 254 12 255
    , Color.rgba 50 64 230 255
    , Color.rgba 5 0 20 255
    , Color.rgba 255 245 244 255
    ]
        |> List.repeat 25
        |> List.concat
        |> Array.fromList


swatches : Swatches
swatches =
    { primary = Color.rgba 176 166 154 255
    , first = Color.black
    , second = Color.white
    , third = Color.rgba 241 29 35 255
    , keyIsDown = False
    }
