module Tool.Select
    exposing
        ( handleClientMouseMovement
        , handleClientMouseUp
        , handleScreenMouseDown
        )

import Canvas
import Canvas.Helpers
import Color exposing (Color)
import Data.Position as Position exposing (Position)
import Draw
import Draw.Model
import History.Helpers as History
import Model exposing (Model)
import Position.Helpers
import Selection.Model as Selection
import Tool.Data exposing (Tool(Select))


handleScreenMouseDown : Position -> Model -> Model
handleScreenMouseDown clientPos model =
    let
        positionOnCanvas =
            Position.Helpers.onCanvas model clientPos
    in
    { model
        | tool = Select (Just positionOnCanvas)
        , draws =
            Draw.rectangle
                model.color.swatches.top
                positionOnCanvas
                positionOnCanvas
                |> Draw.Model.setAtRender
                |> Draw.Model.applyTo model.draws
    }
        |> handleExistingSelection


handleClientMouseMovement : Position -> Position -> Model -> Model
handleClientMouseMovement newPosition priorPosition model =
    { model
        | draws =
            newPosition
                |> Position.Helpers.onCanvas model
                |> Draw.rectangle
                    (displace model.color.swatches.bottom)
                    priorPosition
                |> Draw.Model.setAtRender
                |> Draw.Model.applyTo model.draws
    }


displace : Color -> Color
displace color =
    let
        { hue, saturation, lightness } =
            Color.toHsl color
    in
    if isNaN hue then
        Color.hsl (lightness * 2 * pi) 0.5 0.5
    else
        Color.hsl (hue - degrees 120) saturation (1 - lightness)


handleClientMouseUp : Position -> Position -> Model -> Model
handleClientMouseUp newPosition priorPosition model =
    let
        positionOnCanvas =
            Position.Helpers.onCanvas model newPosition
    in
    if positionOnCanvas == priorPosition then
        { model
            | draws =
                Draw.Model.clearAtRender
                    model.draws
            , tool = Select Nothing
        }
    else
        let
            ( newSelection, drawOp ) =
                Draw.getSelection
                    positionOnCanvas
                    priorPosition
                    model.color.swatches.bottom
                    model.canvas.main
        in
        { model
            | tool = Select Nothing
            , draws =
                drawOp
                    |> Draw.Model.addToPending
                    |> Draw.Model.applyTo model.draws
                    |> Draw.Model.clearAtRender
            , selection =
                { position =
                    Position.min priorPosition positionOnCanvas
                , canvas = newSelection
                , origin = Selection.MainCanvas
                }
                    |> Just
        }
            |> History.canvas



-- HELPER --


handleExistingSelection : Model -> Model
handleExistingSelection model =
    case model.selection of
        Just { position, canvas, origin } ->
            { model
                | draws =
                    Draw.pasteSelection position canvas
                        |> Draw.Model.addToPending
                        |> Draw.Model.applyTo model.draws
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
