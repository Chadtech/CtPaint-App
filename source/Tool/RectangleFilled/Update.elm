module Tool.RectangleFilled.Update exposing (update)

import Canvas exposing (Size)
import Draw.Rectangle as Rectangle
import Draw.Util exposing (makeRectParams)
import History.Update as History
import Model exposing (Model)
import Mouse exposing (Position)
import Tool.RectangleFilled.Types exposing (Msg(..))
import Tool.Types exposing (Tool(..))
import Tool.Util exposing (adjustPosition)
import Util exposing (tbw)


update : Msg -> Maybe Position -> Model -> Model
update message toolModel model =
    case ( message, toolModel ) of
        ( OnScreenMouseDown position, Nothing ) ->
            let
                adjustedPosition =
                    adjustPosition model 0 position
            in
            { model
                | tool =
                    RectangleFilled
                        (Just adjustedPosition)
                , drawAtRender =
                    Rectangle.fill
                        model.swatches.primary
                        (Size 1 1)
                        adjustedPosition
            }
                |> History.addCanvas

        ( SubMouseMove position, Just priorPosition ) ->
            let
                ( drawPosition, size ) =
                    makeRectParams
                        (adjustPosition model tbw position)
                        priorPosition
            in
            { model
                | drawAtRender =
                    Rectangle.fill
                        model.swatches.primary
                        size
                        drawPosition
            }

        ( SubMouseUp position, Just priorPosition ) ->
            let
                ( drawPosition, size ) =
                    makeRectParams
                        (adjustPosition model tbw position)
                        priorPosition
            in
            { model
                | tool = RectangleFilled Nothing
                , drawAtRender = Canvas.batch []
                , pendingDraw =
                    Canvas.batch
                        [ model.pendingDraw
                        , Rectangle.fill
                            model.swatches.primary
                            size
                            drawPosition
                        ]
            }

        _ ->
            model
