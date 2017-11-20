module Tool.Line.Update exposing (update)

import Canvas exposing (Size)
import Data.Tool exposing (Tool(Line))
import Draw
import Helpers.History as History
import Mouse exposing (Position)
import Tool.Line exposing (Msg(..))
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
                    Line (Just adjustedPosition)
                , drawAtRender =
                    Draw.line
                        model.swatches.primary
                        adjustedPosition
                        adjustedPosition
            }
                |> History.canvas

        ( SubMouseMove position, Just priorPosition ) ->
            { model
                | drawAtRender =
                    Draw.line
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
                        , Draw.line
                            model.swatches.primary
                            priorPosition
                            (adjustPosition model tbw position)
                        ]
            }

        _ ->
            model
