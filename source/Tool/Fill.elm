module Tool.Fill exposing (..)

import Canvas exposing (DrawOp(..))
import Draw
import Helpers.History as History
import Model exposing (Model)
import MouseEvents exposing (MouseEvent)
import Tool.Util exposing (adjustPosition)
import Util exposing (tbw, toPoint)


screenMouseUp : MouseEvent -> Model -> Model
screenMouseUp { clientPos } model =
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
