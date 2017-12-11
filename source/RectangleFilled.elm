module RectangleFilled
    exposing
        ( handleClientMouseMovement
        , handleClientMouseUp
        , handleScreenMouseDown
        )

import Canvas exposing (Size)
import Data.Tool exposing (Tool(..))
import Draw exposing (makeRectParams)
import Helpers.History as History
import Helpers.Tool exposing (adjustPosition)
import Model exposing (Model)
import Mouse exposing (Position)


handleScreenMouseDown : Position -> Model -> Model
handleScreenMouseDown clientPos model =
    let
        adjustedPosition =
            adjustPosition model clientPos
    in
    { model
        | tool =
            adjustedPosition
                |> Just
                |> RectangleFilled
        , drawAtRender =
            Draw.filledRectangle
                model.color.swatches.primary
                (Size 1 1)
                adjustedPosition
    }
        |> History.canvas


handleClientMouseMovement : Position -> Position -> Model -> Model
handleClientMouseMovement newPosition priorPosition model =
    let
        ( drawPosition, size ) =
            makeRectParams
                (adjustPosition model newPosition)
                priorPosition
    in
    { model
        | drawAtRender =
            Draw.filledRectangle
                model.color.swatches.primary
                size
                drawPosition
    }


handleClientMouseUp : Position -> Position -> Model -> Model
handleClientMouseUp newPosition priorPosition model =
    let
        ( drawPosition, size ) =
            makeRectParams
                (adjustPosition model newPosition)
                priorPosition
    in
    { model
        | tool = RectangleFilled Nothing
        , drawAtRender = Canvas.batch []
        , pendingDraw =
            [ model.pendingDraw
            , Draw.filledRectangle
                model.color.swatches.primary
                size
                drawPosition
            ]
                |> Canvas.batch
    }
