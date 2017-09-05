module Draw.Line exposing (draw)

import Canvas exposing (DrawOp(..))
import Color exposing (Color)
import Draw.Pixel as Pixel
import Mouse exposing (Position)
import RasterShapes as Shapes
import Util exposing (toPoint)


draw : Color -> Position -> Position -> DrawOp
draw color p0 p1 =
    Shapes.line p0 p1
        |> List.map (toPoint >> Pixel.draw color)
        |> Canvas.batch
