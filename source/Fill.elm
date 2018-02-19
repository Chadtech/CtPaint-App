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
    in
    if isntTheSameColor model positionOnCanvas then
        { model
            | pendingDraw =
                [ model.pendingDraw
                , PixelFill
                    model.color.swatches.top
                    (toPoint positionOnCanvas)
                ]
                    |> Canvas.batch
        }
            |> History.canvas
    else
        model


isntTheSameColor : Model -> Position -> Bool
isntTheSameColor { canvas, color } position =
    Draw.colorAt position canvas /= color.swatches.top
