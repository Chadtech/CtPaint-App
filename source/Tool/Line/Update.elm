module Tool.Line.Update exposing (update)

import Main.Model exposing (Model)
import Tool.Line.Types exposing (Message(..))
import Tool.Types exposing (Tool(..))
import Tool.Util exposing (adjustPosition)
import Mouse exposing (Position)
import Draw.Line as Line
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
                        Line (Just adjustedPosition)
                    , drawAtRender =
                        Line.draw
                            model.swatches.primary
                            adjustedPosition
                            adjustedPosition
                }
                    |> History.addCanvas

        ( SubMouseMove position, Just priorPosition ) ->
            { model
                | drawAtRender =
                    Line.draw
                        model.swatches.primary
                        priorPosition
                        (adjustPosition model tbw position)
            }

        ( SubMouseUp position, Just priorPosition ) ->
            { model
                | tool = Line Nothing
                , drawAtRender = Canvas.batch []
                , pendingDraw =
                    Canvas.batch
                        [ model.pendingDraw
                        , Line.draw
                            model.swatches.primary
                            priorPosition
                            (adjustPosition model tbw position)
                        ]
            }

        _ ->
            model
