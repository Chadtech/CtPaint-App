module Tool.Fill exposing (..)

import Canvas exposing (DrawOp(..))
import Draw
import History
import MouseEvents exposing (MouseEvent)
import Tool.Util exposing (adjustPosition)
import Types exposing (Model)
import Util exposing (tbw, toPoint)


screenMouseUp : MouseEvent -> Model -> Model
screenMouseUp { clientPos } model =
    let
        positionOnCanvas =
            adjustPosition model tbw clientPos

        colorAtPosition =
            Draw.colorAt
                positionOnCanvas
                model.canvas
    in
    if colorAtPosition /= model.swatches.primary then
        { model
            | pendingDraw =
                Canvas.batch
                    [ model.pendingDraw
                    , PixelFill
                        model.swatches.primary
                        (toPoint positionOnCanvas)
                    ]
        }
            |> History.addCanvas
    else
        model
