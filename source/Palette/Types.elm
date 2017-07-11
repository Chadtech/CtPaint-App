module Palette.Types exposing (..)

import Color exposing (Color)
import ParseInt


type alias Swatches =
    { bottomLeft : Color
    , bottomRight : Color
    , topLeft : Color
    , topRight : Color
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
