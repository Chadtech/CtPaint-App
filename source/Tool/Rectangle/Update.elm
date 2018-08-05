module Tool.Rectangle.Update
    exposing
        ( update
        )

import Data.Position exposing (Position)
import Draw
import Draw.Model
import History.Helpers as History
import Model exposing (Model)
import Mouse.Extra exposing (Button)
import Tool.Data as Tool
import Tool.Helpers exposing (getColor)
import Tool.Msg exposing (Msg(..))
import Tool.Rectangle.Model as Rectangle


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
                |> Draw.Model.addToPending
                |> Draw.Model.applyTo model.draws
                |> Draw.Model.clearAtRender
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
                |> Draw.Model.setAtRender
                |> Draw.Model.applyTo model.draws
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
                |> Draw.Model.setAtRender
                |> Draw.Model.applyTo model.draws
    }
