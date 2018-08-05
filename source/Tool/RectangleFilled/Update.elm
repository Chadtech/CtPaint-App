module Tool.RectangleFilled.Update
    exposing
        ( update
        )

import Data.Position exposing (Position)
import Data.Size as Size
import Draw
import Draw.Model
import History.Helpers as History
import Model exposing (Model)
import Mouse.Extra exposing (Button)
import Tool.Data as Tool
import Tool.Helpers exposing (getColor)
import Tool.Msg exposing (Msg(..))
import Tool.RectangleFilled.Model as RectangleFilled


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
                |> Tool.RectangleFilled
        , draws =
            Draw.filledRectangle
                (getColor mouseButton model.color.swatches)
                { width = 1, height = 1 }
                newPositionOnCanvas
                |> Draw.Model.setAtRender
                |> Draw.Model.applyTo model.draws
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
                |> Draw.Model.setAtRender
                |> Draw.Model.applyTo model.draws
    }
