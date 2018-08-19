module Tool.Line.Update
    exposing
        ( update
        )

import Canvas.Draw as Draw
import Canvas.Draw.Model as DrawModel
import Data.Position exposing (Position)
import History.Helpers as History
import Html.Mouse exposing (Button)
import Model exposing (Model)
import Tool.Data as Tool
import Tool.Line.Model as Line
import Tool.Msg exposing (Msg(..))
import Tool.Util exposing (getColor)


update : Msg -> Maybe Line.Model -> Model -> Model
update msg maybeLineModel model =
    case msg of
        WorkareaMouseUp _ ->
            model

        WorkareaMouseDown button newPositionOnCanvas ->
            if maybeLineModel == Nothing then
                handleWorkareaMouseDown
                    button
                    newPositionOnCanvas
                    model
            else
                model

        WindowMouseMove positionOnCanvas ->
            case maybeLineModel of
                Just lineModel ->
                    handleWindowMouseMove
                        positionOnCanvas
                        lineModel
                        model

                Nothing ->
                    model

        WindowMouseUp positionOnCanvas ->
            case maybeLineModel of
                Just lineModel ->
                    handleWindowMouseUp
                        positionOnCanvas
                        lineModel
                        model

                Nothing ->
                    model


handleWindowMouseUp : Position -> Line.Model -> Model -> Model
handleWindowMouseUp newPositionOnCanvas { initialClickPositionOnCanvas, mouseButton } model =
    { model
        | tool = Tool.Line Nothing
        , draws =
            Draw.line
                (getColor mouseButton model.color.swatches)
                initialClickPositionOnCanvas
                newPositionOnCanvas
                |> DrawModel.addToPending
                |> DrawModel.applyTo model.draws
                |> DrawModel.clearAtRender
    }


handleWorkareaMouseDown : Button -> Position -> Model -> Model
handleWorkareaMouseDown mouseButton newPositionOnCanvas model =
    { model
        | tool =
            { initialClickPositionOnCanvas = newPositionOnCanvas
            , mouseButton = mouseButton
            }
                |> Just
                |> Tool.Line
        , draws =
            Draw.line
                (getColor mouseButton model.color.swatches)
                newPositionOnCanvas
                newPositionOnCanvas
                |> DrawModel.setAtRender
                |> DrawModel.applyTo model.draws
    }
        |> History.canvas


handleWindowMouseMove : Position -> Line.Model -> Model -> Model
handleWindowMouseMove newPositionOnCanvas { initialClickPositionOnCanvas, mouseButton } model =
    { model
        | draws =
            Draw.line
                (getColor mouseButton model.color.swatches)
                initialClickPositionOnCanvas
                newPositionOnCanvas
                |> DrawModel.setAtRender
                |> DrawModel.applyTo model.draws
    }
