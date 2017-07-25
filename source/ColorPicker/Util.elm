module ColorPicker.Util exposing (doesntHaveHue)

import Color exposing (Color)
import Util


doesntHaveHue : Color -> Bool
doesntHaveHue color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
        Util.allTrue
            [ red == green
            , green == blue
            , blue == red
            ]
