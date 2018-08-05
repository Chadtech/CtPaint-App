module Tool.Hand.Update
    exposing
        ( update
        )

import Canvas.Model as Canvas
import Data.Position as Position
    exposing
        ( Position
        )
import Model exposing (Model)
import Mouse.Extra exposing (Button)
import Selection.Model as Selection
import Tool.Data as Tool
import Tool.Hand.Model as Hand
import Tool.Msg exposing (Msg(..))


update : Msg -> Maybe Hand.Model -> Model -> Model
update msg maybeHandModel model =
    case msg of
        WorkareaMouseUp _ ->
            model

        WorkareaMouseDown button positionOnCanvas ->
            handleWorkareaMouseDown
                button
                positionOnCanvas
                model

        WindowMouseMove positionOnCanvas ->
            case maybeHandModel of
                Just handModel ->
                    case model.selection of
                        Just selection ->
                            handleWindowMouseMoveSelection
                                positionOnCanvas
                                handModel
                                selection
                                model

                        Nothing ->
                            handleWindowMouseMoveMainCanvas
                                positionOnCanvas
                                handModel
                                model

                Nothing ->
                    model

        WindowMouseUp _ ->
            { model | tool = Tool.Hand Nothing }


handleWorkareaMouseDown : Button -> Position -> Model -> Model
handleWorkareaMouseDown button positionOnCanvas model =
    { model
        | tool =
            { initialCanvasPosition =
                getInitialPosition model
            , mousePositionInWindow =
                positionOnCanvas
            }
                |> Just
                |> Tool.Hand
    }


getInitialPosition : Model -> Position
getInitialPosition model =
    case model.selection of
        Just { position } ->
            position

        Nothing ->
            model.canvas.position


handleWindowMouseMoveMainCanvas : Position -> Hand.Model -> Model -> Model
handleWindowMouseMoveMainCanvas newPositionOnCanvas handModel model =
    { model
        | canvas =
            newPositionOnCanvas
                |> Position.subtract handModel.mousePositionInWindow
                |> Position.add handModel.initialCanvasPosition
                |> Canvas.setPosition
                |> Canvas.applyTo model.canvas
    }


handleWindowMouseMoveSelection : Position -> Hand.Model -> Selection.Model -> Model -> Model
handleWindowMouseMoveSelection newPositionOnCanvas handModel selection model =
    { model
        | selection =
            newPositionOnCanvas
                |> Position.subtract handModel.mousePositionInWindow
                |> Position.divideBy model.zoom
                |> Position.add handModel.initialCanvasPosition
                |> Selection.setPosition
                |> Selection.applyTo selection
                |> Just
    }
