module Draw.Crop exposing (crop)

import Mouse exposing (Position)
import Util exposing (toSize, toPoint, positionMin)
import Canvas
    exposing
        ( Canvas
        , Point
        , Size
        , DrawOp(..)
        , DrawImageParams(..)
        )


crop : Position -> Position -> Canvas -> Canvas
crop p q canvas =
    let
        origin : Position
        origin =
            positionMin p q

        size : Size
        size =
            toSize p q

        cropOp : DrawOp
        cropOp =
            [ CropScaled
                (toPoint origin)
                size
                (Point 0 0)
                size
                |> DrawImage canvas
            ]
                |> Canvas.batch
    in
        Canvas.draw
            cropOp
            (Canvas.initialize size)
