module Tool.Pencil.Update exposing (..)

import Tool.Pencil.Types exposing (Message(..))
import Tool.Types exposing (Tool(..))
import Main.Model exposing (Model)
import Mouse exposing (Position)
import Draw.Line as Line
import Canvas exposing (DrawOp(..))


update : Message -> Maybe Position -> Model -> Model
update message tool ({ canvasPosition } as model) =
    case ( message, tool ) of
        ( OnScreenMouseDown position, Nothing ) ->
            { model
                | tool =
                    let
                        { canvasPosition } =
                            model

                        adjustedPosition =
                            Position
                                (position.x - canvasPosition.x)
                                (position.y - canvasPosition.y)
                    in
                        Pencil (Just adjustedPosition)
            }

        ( SubMouseMove position, Just priorPosition ) ->
            let
                adjustedPosition =
                    Position
                        (position.x - canvasPosition.x - 29)
                        (position.y - canvasPosition.y)
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
