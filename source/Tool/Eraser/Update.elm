module Tool.Eraser.Update exposing (update)

import Canvas.Draw as Draw
import Canvas.Draw.Model as DrawModel
import Data.Position exposing (Position)
import History.Helpers as History
import Html.Mouse exposing (Button)
import Model exposing (Model)
import Tool.Data as Tool
import Tool.Eraser.Model as Eraser
import Tool.Msg exposing (Msg(..))
import Tool.Util exposing (getColor)


update : Msg -> Maybe Eraser.Model -> Model -> Model
update msg maybeEraserModel model =
    case msg of
        WorkareaMouseUp _ ->
            model

        WorkareaMouseDown button newPositionOnCanvas ->
            if maybeEraserModel == Nothing then
                handleWorkareaMouseDown
                    button
                    newPositionOnCanvas
                    model
            else
                model

        WindowMouseMove positionOnCanvas ->
            case maybeEraserModel of
                Just eraserModel ->
                    handleWindowMouseMove
                        positionOnCanvas
                        eraserModel
                        model

                Nothing ->
                    model

        WindowMouseUp positionOnCanvas ->
            case maybeEraserModel of
                Just eraserModel ->
                    handleWindowMouseUp
                        positionOnCanvas
                        eraserModel
                        model

                Nothing ->
                    model


handleWindowMouseUp : Position -> Eraser.Model -> Model -> Model
handleWindowMouseUp newPositionOnCanvas { mousePositionOnCanvas, mouseButton } model =
    { model
        | tool = Tool.Eraser Nothing
        , draws =
            Draw.eraser
                (getColor mouseButton model.color.swatches)
                model.eraserSize
                mousePositionOnCanvas
                newPositionOnCanvas
                |> DrawModel.addToPending
                |> DrawModel.applyTo model.draws
                |> DrawModel.clearAtRender
    }


handleWorkareaMouseDown : Button -> Position -> Model -> Model
handleWorkareaMouseDown mouseButton newPositionOnCanvas model =
    { model
        | tool =
            { mousePositionOnCanvas = newPositionOnCanvas
            , mouseButton = mouseButton
            }
                |> Just
                |> Tool.Eraser
        , draws =
            Draw.eraserPoint
                (getColor mouseButton model.color.swatches)
                model.eraserSize
                newPositionOnCanvas
                |> DrawModel.addToPending
                |> DrawModel.applyTo model.draws
    }
        |> History.canvas


handleWindowMouseMove : Position -> Eraser.Model -> Model -> Model
handleWindowMouseMove newPositionOnCanvas { mousePositionOnCanvas, mouseButton } model =
    { model
        | tool =
            { mousePositionOnCanvas = newPositionOnCanvas
            , mouseButton = mouseButton
            }
                |> Just
                |> Tool.Eraser
        , draws =
            Draw.eraser
                (getColor mouseButton model.color.swatches)
                model.eraserSize
                mousePositionOnCanvas
                newPositionOnCanvas
                |> DrawModel.addToPending
                |> DrawModel.applyTo model.draws
    }
