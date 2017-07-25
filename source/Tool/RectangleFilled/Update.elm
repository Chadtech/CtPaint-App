module Tool.RectangleFilled.Update exposing (update)

import Main.Model exposing (Model)
import Tool.RectangleFilled.Types exposing (Message(..))
import Tool.Types exposing (Tool(..))
import Tool.Util exposing (adjustPosition)
import Mouse exposing (Position)
import Draw.Rectangle as Rectangle
import Canvas exposing (Size)


update : Message -> Maybe Position -> Model -> Model
update message toolModel model =
    case ( message, toolModel ) of
        ( OnScreenMouseDown position, Nothing ) ->
            let
                adjustedPosition =
                    adjustPosition model 0 position
            in
                { model
                    | tool =
                        RectangleFilled (Just adjustedPosition)
                    , drawAtRender =
                        Rectangle.fill
                            model.swatches.primary
                            (Size 1 1)
                            adjustedPosition
                }

        ( SubMouseMove position, Just priorPosition ) ->
            let
                adjustedPosition =
                    adjustPosition model 29 position

                size =
                    Size
                        (adjustedPosition.x - priorPosition.x)
                        (adjustedPosition.y - priorPosition.y)
            in
                { model
                    | drawAtRender =
                        Rectangle.fill
                            model.swatches.primary
                            size
                            priorPosition
                }

        ( SubMouseUp position, Just priorPosition ) ->
            let
                adjustedPosition =
                    adjustPosition model 29 position

                size =
                    Size
                        (adjustedPosition.x - priorPosition.x)
                        (adjustedPosition.y - priorPosition.y)

                newDrawOp =
                    Rectangle.fill
                        model.swatches.primary
                        size
                        priorPosition
            in
                { model
                    | tool = RectangleFilled Nothing
                    , drawAtRender = Canvas.batch []
                    , pendingDraw =
                        Canvas.batch
                            [ model.pendingDraw
                            , newDrawOp
                            ]
                }

        _ ->
            model
