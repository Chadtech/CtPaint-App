module Ellipse
    exposing
        ( handleClientMouseMovement
        , handleClientMouseUp
        , handleScreenMouseDown
        )

import Canvas
import Data.Tool exposing (Tool(Ellipse))
import Draw
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
        | tool = Ellipse (Just adjustedPosition)
        , drawAtRender =
            Draw.ellipse
                model.color.swatches.primary
                adjustedPosition
                adjustedPosition
    }
        |> History.canvas


handleClientMouseMovement : Position -> Position -> Model -> Model
handleClientMouseMovement newPosition priorPosition model =
    { model
        | drawAtRender =
            Draw.ellipse
                model.color.swatches.primary
                priorPosition
                (adjustPosition model newPosition)
    }


handleClientMouseUp : Position -> Position -> Model -> Model
handleClientMouseUp newPosition priorPosition model =
    { model
        | tool = Ellipse Nothing
        , drawAtRender = Canvas.batch []
        , pendingDraw =
            [ model.pendingDraw
            , Draw.ellipse
                model.color.swatches.primary
                priorPosition
                (adjustPosition model newPosition)
            ]
                |> Canvas.batch
    }
