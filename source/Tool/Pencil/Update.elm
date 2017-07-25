module Tool.Pencil.Update exposing (..)

import Tool.Pencil.Types exposing (Message(..))
import Tool.Types exposing (Tool(..))
import Tool.Util exposing (adjustPosition)
import Main.Model exposing (Model)
import Mouse exposing (Position)
import Draw.Line as Line
import Canvas exposing (DrawOp(..))
import Util exposing (tbw)
import History.Update as History


update : Message -> Maybe Position -> Model -> Model
update message tool ({ canvasPosition } as model) =
    case ( message, tool ) of
        ( OnScreenMouseDown position, Nothing ) ->
            let
                adjustedPosition =
                    adjustPosition model 0 position
            in
                { model
                    | tool = Pencil (Just adjustedPosition)
                    , pendingDraw =
                        Canvas.batch
                            [ model.pendingDraw
                            , Line.draw
                                model.swatches.primary
                                adjustedPosition
                                adjustedPosition
                            ]
                }
                    |> History.addCanvas

        ( SubMouseMove position, Just priorPosition ) ->
            let
                adjustedPosition =
                    adjustPosition model tbw position
            in
                { model
                    | tool = Pencil (Just adjustedPosition)
                    , pendingDraw =
                        Canvas.batch
                            [ model.pendingDraw
                            , Line.draw
                                model.swatches.primary
                                priorPosition
                                adjustedPosition
                            ]
                }

        ( SubMouseUp, _ ) ->
            { model
                | tool = Pencil Nothing
            }

        _ ->
            model
