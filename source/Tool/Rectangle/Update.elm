module Tool.Rectangle.Update exposing (update)

import Canvas exposing (Size)
import Draw.Rectangle as Rectangle
import History.Update as History
import Mouse exposing (Position)
import Tool exposing (Tool(..))
import Tool.Rectangle exposing (Msg(..))
import Tool.Util exposing (adjustPosition)
import Types exposing (Model)
import Util exposing (tbw)


update : Msg -> Maybe Position -> Model -> Model
update message toolModel model =
    case ( message, toolModel ) of
        ( ScreenMouseDown { clientPos }, Nothing ) ->
            let
                adjustedPosition =
                    adjustPosition model tbw clientPos
            in
            { model
                | tool =
                    Rectangle (Just adjustedPosition)
                , drawAtRender =
                    Rectangle.draw
                        model.swatches.primary
                        adjustedPosition
                        adjustedPosition
            }
                |> History.addCanvas

        ( SubMouseMove position, Just priorPosition ) ->
            { model
                | drawAtRender =
                    Rectangle.draw
                        model.swatches.primary
                        priorPosition
                        (adjustPosition model tbw position)
            }

        ( SubMouseUp position, Just priorPosition ) ->
            { model
                | tool = Rectangle Nothing
                , drawAtRender = Canvas.batch []
                , pendingDraw =
                    Canvas.batch
                        [ model.pendingDraw
                        , Rectangle.draw
                            model.swatches.primary
                            priorPosition
                            (adjustPosition model tbw position)
                        ]
            }

        _ ->
            model
