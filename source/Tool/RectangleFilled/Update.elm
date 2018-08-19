module Tool.RectangleFilled.Update
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
import Tool.Msg exposing (Msg(..))
import Tool.RectangleFilled.Model as RectangleFilled
import Tool.Util exposing (getColor)


update : Msg -> Maybe RectangleFilled.Model -> Model -> Model
update msg maybeRectangleFilledModel model =
    case msg of
        WorkareaMouseUp _ ->
            model

        WorkareaMouseDown button newPositionOnCanvas ->
            if maybeRectangleFilledModel == Nothing then
                handleWorkareaMouseDown
                    button
                    newPositionOnCanvas
                    model
            else
                model

        WindowMouseMove positionOnCanvas ->
            case maybeRectangleFilledModel of
                Just rectangleFilledModel ->
                    handleWindowMouseMove
                        positionOnCanvas
                        rectangleFilledModel
                        model

                Nothing ->
                    model

        WindowMouseUp positionOnCanvas ->
            case maybeRectangleFilledModel of
                Just rectangleFilledModel ->
                    handleWindowMouseUp
                        positionOnCanvas
                        rectangleFilledModel
                        model

                Nothing ->
                    model


handleWindowMouseUp : Position -> RectangleFilled.Model -> Model -> Model
handleWindowMouseUp newPositionOnCanvas { initialClickPositionOnCanvas, mouseButton } model =
    let
        ( drawPosition, size ) =
            Draw.makeRectParams
                newPositionOnCanvas
                initialClickPositionOnCanvas
    in
    { model
        | tool = Tool.RectangleFilled Nothing
        , draws =
            Draw.filledRectangle
                (getColor mouseButton model.color.swatches)
                size
                drawPosition
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
                |> Tool.RectangleFilled
        , draws =
            Draw.filledRectangle
                (getColor mouseButton model.color.swatches)
                { width = 1, height = 1 }
                newPositionOnCanvas
                |> DrawModel.setAtRender
                |> DrawModel.applyTo model.draws
    }
        |> History.canvas


handleWindowMouseMove : Position -> RectangleFilled.Model -> Model -> Model
handleWindowMouseMove newPositionOnCanvas { initialClickPositionOnCanvas, mouseButton } model =
    let
        ( drawPosition, size ) =
            Draw.makeRectParams
                newPositionOnCanvas
                initialClickPositionOnCanvas
    in
    { model
        | draws =
            Draw.filledRectangle
                (getColor mouseButton model.color.swatches)
                size
                drawPosition
                |> DrawModel.setAtRender
                |> DrawModel.applyTo model.draws
    }
