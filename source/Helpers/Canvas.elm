module Helpers.Canvas
    exposing
        ( blank
        , noop
        )

import Canvas exposing (Canvas, DrawOp(..))
import Color


blank : Canvas
blank =
    { width = 400
    , height = 400
    }
        |> Canvas.initialize
        |> fillBlack


noop : DrawOp
noop =
    Canvas.batch []


fillBlack : Canvas -> Canvas
fillBlack canvas =
    Canvas.draw (fillBlackOp canvas) canvas


fillBlackOp : Canvas -> DrawOp
fillBlackOp canvas =
    [ BeginPath
    , Rect { x = 0, y = 0 } (Canvas.getSize canvas)
    , FillStyle Color.black
    , Canvas.Fill
    ]
        |> Canvas.batch
