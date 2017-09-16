module Tool.Select.Update exposing (update)

import Canvas exposing (Point, Size)
import Draw.Rectangle as Rectangle
import Draw.Select as Select
import History.Update as History
import Mouse exposing (Position)
import Tool exposing (Tool(..))
import Tool.Select.Types exposing (..)
import Tool.Util exposing (adjustPosition)
import Types exposing (Model)
import Util exposing (positionMin, tbw)


update : Msg -> Maybe Position -> Model -> Model
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
            }
                |> handleExistingSelection

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



-- HELPER --


handleExistingSelection : Model -> Model
handleExistingSelection model =
    case model.selection of
        Just ( position, selection ) ->
            { model
                | pendingDraw =
                    [ model.pendingDraw
                    , Select.paste position selection
                    ]
                        |> Canvas.batch
                , selection = Nothing
            }
                |> History.addCanvas

        Nothing ->
            model
