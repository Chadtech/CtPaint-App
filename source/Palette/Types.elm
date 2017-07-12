module Palette.Types exposing (..)

import Color exposing (Color)
import ParseInt


type alias Swatches =
    { primary : Color
    , first : Color
    , second : Color
    , third : Color
    , keyIsDown : Bool
    }



-- HELPERS --


toHex : Color -> String
toHex color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
        [ "#"
        , ParseInt.toHex red
        , ParseInt.toHex green
        , ParseInt.toHex blue
        ]
            |> String.concat
