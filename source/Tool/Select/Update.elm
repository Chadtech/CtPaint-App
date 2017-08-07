module Tool.Select.Update exposing (update)

import Main.Model exposing (Model)
import Tool.Select.Types exposing (..)
import Tool.Types exposing (..)
import Tool.Util exposing (adjustPosition)
import Draw.Rectangle as Rectangle
import Draw.Select as Select
import Mouse exposing (Position)
import Canvas exposing (Size, Point)
import Util exposing (tbw, positionMin)


update : Message -> Maybe Position -> Model -> Model
update message maybePosition model =
    case ( message, maybePosition ) of
        ( OnScreenMouseDown position, Nothing ) ->
            let
                adjustedPosition =
                    adjustPosition model 0 position
            in
                { model
                    | tool = Select (Just adjustedPosition)
                    , drawAtRender =
                        Rectangle.draw
                            model.swatches.primary
                            adjustedPosition
                            adjustedPosition
                    , pendingDraw =
                        case model.selection of
                            Just ( selectionPosition, selection ) ->
                                [ model.pendingDraw
                                , Select.paste selectionPosition selection
                                ]
                                    |> Canvas.batch

                            Nothing ->
                                model.pendingDraw
                    , selection = Nothing
                }

        ( SubMouseMove position, Just priorPosition ) ->
            { model
                | drawAtRender =
                    Rectangle.draw
                        model.swatches.second
                        priorPosition
                        (adjustPosition model tbw position)
            }

        ( SubMouseUp position, Just priorPosition ) ->
            let
                adjustedPosition =
                    adjustPosition model tbw position
            in
                if adjustedPosition == priorPosition then
                    { model
                        | tool = Select Nothing
                        , drawAtRender = Canvas.batch []
                    }
                else
                    let
                        ( newSelection, drawOp ) =
                            Select.get
                                adjustedPosition
                                priorPosition
                                model.swatches.second
                                model.canvas
                    in
                        { model
                            | tool = Rectangle Nothing
                            , pendingDraw =
                                Canvas.batch
                                    [ model.pendingDraw
                                    , drawOp
                                    ]
                            , selection =
                                Just
                                    ( positionMin
                                        priorPosition
                                        adjustedPosition
                                    , newSelection
                                    )
                            , tool = Select Nothing
                        }

        _ ->
            model
