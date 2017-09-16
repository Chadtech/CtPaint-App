module Tool.Fill.Update exposing (update)

import Canvas exposing (Canvas, DrawOp(..), Point, Size)
import Draw.Util
import History.Update as History
import Model exposing (Model)
import Tool.Fill.Types exposing (Msg(..))
import Tool.Util exposing (adjustPosition)
import Util exposing (maybeCons, tbw, toPoint)


update : Msg -> Model -> Model
update message model =
    case message of
        ScreenMouseUp { clientPos } ->
            let
                positonOnCanvas =
                    adjustPosition model tbw clientPos

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
