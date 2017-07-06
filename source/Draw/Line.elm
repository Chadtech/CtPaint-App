module Draw.Line exposing (draw)

import Mouse exposing (Position)
import Canvas exposing (DrawOp(..))


draw : Position -> Position -> DrawOp
draw p0 p1 =
    Canvas.batch []
