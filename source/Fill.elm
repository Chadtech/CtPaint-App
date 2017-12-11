module Fill exposing (handleScreenMouseUp)

import Canvas exposing (DrawOp(PixelFill))
import Draw
import Helpers.History as History
import Helpers.Tool exposing (adjustPosition)
import Model exposing (Model)
import Mouse exposing (Position)
import Util exposing (toPoint)


handleScreenMouseUp : Position -> Model -> Model
handleScreenMouseUp clientPos model =
    let
        positionOnCanvas =
            adjustPosition model clientPos

        colorAtPosition =
            Draw.colorAt
                positionOnCanvas
                model.canvas
    in
    if colorAtPosition /= model.color.swatches.primary then
        { model
            | pendingDraw =
                [ model.pendingDraw
                , PixelFill
                    model.color.swatches.primary
                    (toPoint positionOnCanvas)
                ]
                    |> Canvas.batch
        }
            |> History.canvas
    else
        model
