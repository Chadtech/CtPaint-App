module Select
    exposing
        ( handleClientMouseMovement
        , handleClientMouseUp
        , handleScreenMouseDown
        )

import Canvas
import Color exposing (Color)
import Data.Tool exposing (Tool(Select))
import Draw
import Helpers.History as History
import Helpers.Tool exposing (adjustPosition)
import Model exposing (Model)
import Mouse exposing (Position)
import Tuple.Infix exposing ((&))
import Util exposing (positionMin)


handleScreenMouseDown : Position -> Model -> Model
handleScreenMouseDown clientPos model =
    let
        adjustedPosition =
            adjustPosition model clientPos
    in
    { model
        | tool = Select (Just adjustedPosition)
        , drawAtRender =
            Draw.rectangle
                model.color.swatches.top
                adjustedPosition
                adjustedPosition
    }
        |> handleExistingSelection


handleClientMouseMovement : Position -> Position -> Model -> Model
handleClientMouseMovement newPosition priorPosition model =
    { model
        | drawAtRender =
            Draw.rectangle
                (displace model.color.swatches.bottom)
                priorPosition
                (adjustPosition model newPosition)
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
        adjustedPosition =
            adjustPosition model newPosition
    in
    if adjustedPosition == priorPosition then
        { model
            | drawAtRender = Canvas.batch []
            , tool = Select Nothing
        }
    else
        let
            ( newSelection, drawOp ) =
                Draw.getSelection
                    adjustedPosition
                    priorPosition
                    model.color.swatches.bottom
                    model.canvas
        in
        { model
            | tool = Select Nothing
            , pendingDraw =
                [ model.pendingDraw
                , drawOp
                ]
                    |> Canvas.batch
            , drawAtRender = Canvas.batch []
            , selection =
                adjustedPosition
                    |> positionMin priorPosition
                    & newSelection
                    |> Just
        }



-- HELPER --


handleExistingSelection : Model -> Model
handleExistingSelection model =
    case model.selection of
        Just ( position, selection ) ->
            { model
                | pendingDraw =
                    [ model.pendingDraw
                    , Draw.pasteSelection position selection
                    ]
                        |> Canvas.batch
                , selection = Nothing
            }
                |> History.canvas

        Nothing ->
            model
