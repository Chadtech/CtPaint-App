module Tool.Fill.Update exposing (update)

import Main.Model exposing (Model)
import Tool.Fill.Types exposing (Message(..))
import Tool.Util exposing (adjustPosition)
import Util exposing (tbw, toPoint, maybeCons)
import Draw.Util
import Canvas exposing (Size, Point, Canvas, DrawOp(..))
import History.Update as History


update : Message -> Model -> Model
update message model =
    case message of
        SubMouseUp position ->
            let
                positonOnCanvas =
                    adjustPosition model tbw position

                colorAtPosition =
                    Draw.Util.colorAt
                        positonOnCanvas
                        model.canvas
            in
                if colorAtPosition /= model.swatches.primary then
                    { model
                        | pendingDraw =
                            Canvas.batch
                                [ model.pendingDraw
                                , PixelFill
                                    model.swatches.primary
                                    (toPoint positonOnCanvas)
                                ]
                    }
                        |> History.addCanvas
                else
                    model
