module Draw.Pixel exposing (draw)

import Canvas exposing (Point, Size, DrawOp(..))
import Color exposing (Color)


draw : Color -> Point -> DrawOp
draw color point =
    PutImageData
        (fromColor color)
        (Size 1 1)
        point


fromColor : Color -> List Int
fromColor color =
    let
        { red, green, blue, alpha } =
            Color.toRgb color
    in
        [ red
        , green
        , blue
        , round (alpha * 255)
        ]
