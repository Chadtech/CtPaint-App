module Tool.Pencil.Update
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
import Tool.Pencil.Model as Pencil


update : Msg -> Maybe Pencil.Model -> Model -> Model
update msg maybePencilModel model =
    case msg of
        WorkareaMouseUp _ ->
            model

        WorkareaMouseDown button newPositionOnCanvas ->
            if maybePencilModel == Nothing then
                handleWorkareaMouseDown
                    button
                    newPositionOnCanvas
                    model
            else
                model

        WindowMouseMove positionOnCanvas ->
            case maybePencilModel of
                Just pencilModel ->
                    handleWindowMouseMove
                        positionOnCanvas
                        pencilModel
                        model

                Nothing ->
                    model

        WindowMouseUp _ ->
            { model | tool = Tool.Pencil Nothing }


handleWindowMouseMove : Position -> Pencil.Model -> Model -> Model
handleWindowMouseMove newPositionOnCanvas { mousePositionOnCanvas, mouseButton } model =
    { model
        | tool =
            { mousePositionOnCanvas = newPositionOnCanvas
            , mouseButton = mouseButton
            }
                |> Just
                |> Tool.Pencil
        , draws =
            Draw.line
                (getColor mouseButton model.color.swatches)
                mousePositionOnCanvas
                newPositionOnCanvas
                |> Draw.Model.addToPending
                |> Draw.Model.applyTo model.draws
    }


handleWorkareaMouseDown : Button -> Position -> Model -> Model
handleWorkareaMouseDown mouseButton newPositionOnCanvas model =
    { model
        | tool =
            { mousePositionOnCanvas = newPositionOnCanvas
            , mouseButton = mouseButton
            }
                |> Just
                |> Tool.Pencil
        , draws =
            Draw.line
                (getColor mouseButton model.color.swatches)
                newPositionOnCanvas
                newPositionOnCanvas
                |> Draw.Model.addToPending
                |> Draw.Model.applyTo model.draws
    }
        |> History.canvas
