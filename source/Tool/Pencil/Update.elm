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

        ( SubMouseMove position, Just priorPosition ) ->
            let
                adjustedPosition =
                    adjustPosition model 29 position
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


adjustPosition : Model -> Int -> Position -> Position
adjustPosition { canvas, canvasPosition, zoom } offset { x, y } =
    let
        x_ =
            List.sum
                [ x
                , -canvasPosition.x
                , -offset
                ]

        y_ =
            List.sum
                [ y
                , -canvasPosition.y
                , -offset
                ]
    in
        Position (x_ // zoom) (y_ // zoom)
