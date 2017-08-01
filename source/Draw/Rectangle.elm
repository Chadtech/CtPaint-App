module Draw.Rectangle exposing (draw, fill)

import Mouse exposing (Position)
import Canvas exposing (DrawOp(..), Size)
import RasterShapes as Shapes
import Util exposing (toPoint)
import Color exposing (Color)
import Draw.Pixel as Pixel


draw : Color -> Position -> Position -> DrawOp
draw color p q =
    Shapes.rectangle2 p q
        |> List.map (toPoint >> Pixel.draw color)
        |> Canvas.batch


fill : Color -> Size -> Position -> DrawOp
fill color size position =
    [ BeginPath
    , Rect (toPoint position) size
    , FillStyle color
    , Fill
    ]
        |> Canvas.batch
