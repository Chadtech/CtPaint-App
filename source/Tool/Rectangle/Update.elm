module Tool.Rectangle.Update exposing (update)

import Canvas
import Data.Tool exposing (Tool(..))
import Draw
import Helpers.History as History
import Model exposing (Model)
import Mouse exposing (Position)
import Tool.Rectangle exposing (Msg(..))
import Tool.Util exposing (adjustPosition)
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
                    Draw.rectangle
                        model.swatches.primary
                        adjustedPosition
                        adjustedPosition
            }
                |> History.canvas

        ( SubMouseMove position, Just priorPosition ) ->
            { model
                | drawAtRender =
                    Draw.rectangle
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
                        , Draw.rectangle
                            model.swatches.primary
                            priorPosition
                            (adjustPosition model tbw position)
                        ]
            }

        _ ->
            model
