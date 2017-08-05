module Draw.Select exposing (..)

import Mouse exposing (Position)
import Util exposing (toSize, toPoint, positionMin)
import Draw.Rectangle as Rectangle
import Color exposing (Color)
import Canvas
    exposing
        ( Canvas
        , Point
        , Size
        , DrawOp(..)
        , DrawImageParams(..)
        )


paste : Position -> Canvas -> DrawOp
paste position selection =
    DrawImage selection (At (toPoint position))


get : Position -> Position -> Color -> Canvas -> ( Canvas, DrawOp )
get p q color canvas =
    let
        origin : Position
        origin =
            positionMin p q

        size : Size
        size =
            toSize p q

        cropOp : DrawOp
        cropOp =
            CropScaled
                (toPoint origin)
                size
                (Point 0 0)
                size
                |> DrawImage canvas
    in
        ( Canvas.draw
            cropOp
            (Canvas.initialize size)
        , Rectangle.fill color size origin
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
            CropScaled
                (toPoint origin)
                size
                (Point 0 0)
                size
                |> DrawImage canvas
    in
        Canvas.draw
            cropOp
            (Canvas.initialize size)
