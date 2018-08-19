module Tool.Hand.Update
    exposing
        ( update
        )

import Canvas.Model as Canvas
import Data.Position as Position
    exposing
        ( Position
        )
import Html.Mouse exposing (Button)
import Model exposing (Model)
import Selection.Model as Selection
import Tool.Data as Tool
import Tool.Hand.Model as Hand
import Tool.Msg exposing (Msg(..))


update : Msg -> Maybe Hand.Model -> Model -> Model
update msg maybeHandModel model =
    case msg of
        WorkareaMouseUp _ ->
            model

        WorkareaMouseDown button positionInWindow ->
            handleWorkareaMouseDown
                button
                positionInWindow
                model

        WindowMouseMove positionInWindow ->
            case maybeHandModel of
                Just handModel ->
                    case model.selection of
                        Just selection ->
                            handleWindowMouseMoveSelection
                                positionInWindow
                                handModel
                                selection
                                model

                        Nothing ->
                            handleWindowMouseMoveMainCanvas
                                positionInWindow
                                handModel
                                model

                Nothing ->
                    model

        WindowMouseUp _ ->
            { model | tool = Tool.Hand Nothing }


handleWorkareaMouseDown : Button -> Position -> Model -> Model
handleWorkareaMouseDown button positionInWindow model =
    { model
        | tool =
            { initialCanvasPosition =
                getInitialPosition model
            , mousePositionInWindow =
                positionInWindow
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
handleWindowMouseMoveMainCanvas newPositionInWindow handModel model =
    { model
        | canvas =
            newPositionInWindow
                |> Position.subtract handModel.mousePositionInWindow
                |> Position.add handModel.initialCanvasPosition
                |> Canvas.setPosition
                |> Canvas.applyTo model.canvas
    }


handleWindowMouseMoveSelection : Position -> Hand.Model -> Selection.Model -> Model -> Model
handleWindowMouseMoveSelection newPositionInWindow handModel selection model =
    { model
        | selection =
            newPositionInWindow
                |> Position.subtract handModel.mousePositionInWindow
                |> Position.divideBy model.zoom
                |> Position.add handModel.initialCanvasPosition
                |> Selection.setPosition
                |> Selection.applyTo selection
                |> Just
    }
