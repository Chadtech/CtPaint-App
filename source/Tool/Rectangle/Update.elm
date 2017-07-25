module Tool.Rectangle.Update exposing (update)

import Main.Model exposing (Model)
import Tool.Rectangle.Types exposing (Message(..))
import Tool.Types exposing (Tool(..))
import Tool.Util exposing (adjustPosition)
import Mouse exposing (Position)
import Draw.Rectangle as Rectangle
import Draw.Util exposing (makeRectParams)
import Canvas exposing (Size)
import Util exposing (tbw)
import History.Update as History


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
                        Rectangle (Just adjustedPosition)
                    , drawAtRender =
                        Rectangle.draw
                            model.swatches.primary
                            (Size 1 1)
                            adjustedPosition
                }

        ( SubMouseMove position, Just priorPosition ) ->
            let
                ( drawPosition, size ) =
                    makeRectParams
                        (adjustPosition model tbw position)
                        priorPosition
            in
                { model
                    | drawAtRender =
                        Rectangle.draw
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
                    | tool = Rectangle Nothing
                    , drawAtRender = Canvas.batch []
                    , pendingDraw =
                        Canvas.batch
                            [ model.pendingDraw
                            , Rectangle.draw
                                model.swatches.primary
                                size
                                drawPosition
                            ]
                }
                    |> History.addCanvas

        _ ->
            model
