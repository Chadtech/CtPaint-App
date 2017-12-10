module Tool.Line.Update exposing (update)

import Canvas exposing (Size)
import Data.Tool exposing (Tool(Line))
import Draw
import Helpers.History as History
import Model exposing (Model)
import Mouse exposing (Position)
import Tool.Line exposing (Msg(..))
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
                | tool = Line (Just adjustedPosition)
                , drawAtRender =
                    Draw.line
                        model.color.swatches.primary
                        adjustedPosition
                        adjustedPosition
            }
                |> History.canvas

        ( SubMouseMove position, Just priorPosition ) ->
            { model
                | drawAtRender =
                    Draw.line
                        model.color.swatches.primary
                        priorPosition
                        (adjustPosition model position)
            }

        ( SubMouseUp position, Just priorPosition ) ->
            { model
                | tool = Line Nothing
                , drawAtRender = Canvas.batch []
                , pendingDraw =
                    [ model.pendingDraw
                    , Draw.line
                        model.color.swatches.primary
                        priorPosition
                        (adjustPosition model position)
                    ]
                        |> Canvas.batch
            }

        _ ->
            model
