module Tool.RectangleFilled.Update exposing (update)

import Canvas exposing (Size)
import Data.Tool exposing (Tool(..))
import Draw exposing (makeRectParams)
import Helpers.History as History
import Model exposing (Model)
import Mouse exposing (Position)
import Tool.RectangleFilled exposing (Msg(..))
import Tool.Util exposing (adjustPosition)


update : Msg -> Maybe Position -> Model -> Model
update message toolModel model =
    case ( message, toolModel ) of
        ( ScreenMouseDown { clientPos }, Nothing ) ->
            let
                adjustedPosition =
                    adjustPosition model clientPos
            in
            { model
                | tool =
                    adjustedPosition
                        |> Just
                        |> RectangleFilled
                , drawAtRender =
                    Draw.filledRectangle
                        model.color.swatches.primary
                        (Size 1 1)
                        adjustedPosition
            }
                |> History.canvas

        ( SubMouseMove position, Just priorPosition ) ->
            let
                ( drawPosition, size ) =
                    makeRectParams
                        (adjustPosition model position)
                        priorPosition
            in
            { model
                | drawAtRender =
                    Draw.filledRectangle
                        model.color.swatches.primary
                        size
                        drawPosition
            }

        ( SubMouseUp position, Just priorPosition ) ->
            let
                ( drawPosition, size ) =
                    makeRectParams
                        (adjustPosition model position)
                        priorPosition
            in
            { model
                | tool = RectangleFilled Nothing
                , drawAtRender = Canvas.batch []
                , pendingDraw =
                    Canvas.batch
                        [ model.pendingDraw
                        , Draw.filledRectangle
                            model.color.swatches.primary
                            size
                            drawPosition
                        ]
            }

        _ ->
            model
