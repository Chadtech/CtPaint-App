module Tool.Rectangle.Update
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
import Tool.Rectangle.Model as Rectangle
import Tool.Util exposing (getColor)


update : Msg -> Maybe Rectangle.Model -> Model -> Model
update msg maybeRectangleModel model =
    case msg of
        WorkareaMouseUp _ ->
            model

        WorkareaMouseDown button newPositionOnCanvas ->
            if maybeRectangleModel == Nothing then
                handleWorkareaMouseDown
                    button
                    newPositionOnCanvas
                    model
            else
                model

        WindowMouseMove positionOnCanvas ->
            case maybeRectangleModel of
                Just rectangleModel ->
                    handleWindowMouseMove
                        positionOnCanvas
                        rectangleModel
                        model

                Nothing ->
                    model

        WindowMouseUp positionOnCanvas ->
            case maybeRectangleModel of
                Just rectangleModel ->
                    handleWindowMouseUp
                        positionOnCanvas
                        rectangleModel
                        model

                Nothing ->
                    model


handleWindowMouseUp : Position -> Rectangle.Model -> Model -> Model
handleWindowMouseUp newPositionOnCanvas { initialClickPositionOnCanvas, mouseButton } model =
    { model
        | tool = Tool.Rectangle Nothing
        , draws =
            Draw.rectangle
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
                |> Tool.Rectangle
        , draws =
            Draw.rectangle
                (getColor mouseButton model.color.swatches)
                newPositionOnCanvas
                newPositionOnCanvas
                |> DrawModel.setAtRender
                |> DrawModel.applyTo model.draws
    }
        |> History.canvas


handleWindowMouseMove : Position -> Rectangle.Model -> Model -> Model
handleWindowMouseMove newPositionOnCanvas { initialClickPositionOnCanvas, mouseButton } model =
    { model
        | draws =
            Draw.rectangle
                (getColor mouseButton model.color.swatches)
                initialClickPositionOnCanvas
                newPositionOnCanvas
                |> DrawModel.setAtRender
                |> DrawModel.applyTo model.draws
    }
