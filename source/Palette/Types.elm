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
        , toHexHelper <| ParseInt.toHex red
        , toHexHelper <| ParseInt.toHex green
        , toHexHelper <| ParseInt.toHex blue
        ]
            |> String.concat


toHexHelper : String -> String
toHexHelper hex =
    if String.length hex > 1 then
        hex
    else
        "0" ++ hex
