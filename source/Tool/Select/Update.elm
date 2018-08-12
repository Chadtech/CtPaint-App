module Tool.Select.Update exposing (update)

import Canvas.Draw as Draw
import Canvas.Draw.Model as CDM
import Color.Util
import History.Helpers as History
import Model exposing (Model)
import Position.Data as Position exposing (Position)
import Selection.Model as Selection
import Tool.Data exposing (Tool(..))
import Tool.Msg exposing (Msg(..))


update : Msg -> Maybe Position -> Model -> Model
update msg maybeSelectModel model =
    case msg of
        WorkareaMouseUp _ ->
            model

        WorkareaMouseDown _ newPositionOnCanvas ->
            if maybeSelectModel == Nothing then
                handleWorkareaMouseDown
                    newPositionOnCanvas
                    model
            else
                model

        WindowMouseMove newPositionOnCanvas ->
            case maybeSelectModel of
                Just positionOnCanvas ->
                    handleWindowMouseMove
                        newPositionOnCanvas
                        positionOnCanvas
                        model

                Nothing ->
                    model

        WindowMouseUp newPositionOnCanvas ->
            case maybeSelectModel of
                Just positionOnCanvas ->
                    handleWindowMouseUp
                        newPositionOnCanvas
                        positionOnCanvas
                        model

                Nothing ->
                    model


handleWindowMouseUp : Position -> Position -> Model -> Model
handleWindowMouseUp newPositionOnCanvas positionOnCanvas model =
    if positionOnCanvas == newPositionOnCanvas then
        { model
            | draws =
                CDM.clearAtRender
                    model.draws
            , tool = Select Nothing
        }
    else
        let
            ( newSelection, drawOp ) =
                Draw.getSelection
                    newPositionOnCanvas
                    positionOnCanvas
                    model.color.swatches.bottom
                    model.canvas.main
        in
        { model
            | tool = Select Nothing
            , draws =
                drawOp
                    |> CDM.addToPending
                    |> CDM.applyTo model.draws
                    |> CDM.clearAtRender
            , selection =
                { position =
                    Position.min
                        positionOnCanvas
                        newPositionOnCanvas
                , canvas = newSelection
                , origin = Selection.MainCanvas
                }
                    |> Just
        }
            |> History.canvas


handleWindowMouseMove : Position -> Position -> Model -> Model
handleWindowMouseMove newPositionOnCanvas positionOnCanvas model =
    { model
        | draws =
            Draw.rectangle
                (Color.Util.rotate model.color.swatches.bottom)
                positionOnCanvas
                newPositionOnCanvas
                |> CDM.setAtRender
                |> CDM.applyTo model.draws
    }


handleWorkareaMouseDown : Position -> Model -> Model
handleWorkareaMouseDown newPositionOnCanvas model =
    { model
        | tool =
            newPositionOnCanvas
                |> Just
                |> Select
        , draws =
            Draw.rectangle
                model.color.swatches.top
                newPositionOnCanvas
                newPositionOnCanvas
                |> CDM.setAtRender
                |> CDM.applyTo model.draws
    }
        |> handleExistingSelection


handleExistingSelection : Model -> Model
handleExistingSelection model =
    case model.selection of
        Just { position, canvas, origin } ->
            { model
                | draws =
                    Draw.pasteSelection position canvas
                        |> CDM.addToPending
                        |> CDM.applyTo model.draws
                , selection = Nothing
            }
                |> historyIf origin

        Nothing ->
            model


historyIf : Selection.Origin -> Model -> Model
historyIf origin model =
    case origin of
        Selection.Other ->
            History.canvas model

        Selection.MainCanvas ->
            model
