module Rectangle
    exposing
        ( handleClientMouseMovement
        , handleClientMouseUp
        , handleScreenMouseDown
        )

import Canvas
import Data.Tool exposing (Tool(..))
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
        | tool = Rectangle (Just adjustedPosition)
        , drawAtRender =
            Draw.rectangle
                model.color.swatches.top
                adjustedPosition
                adjustedPosition
    }
        |> History.canvas


handleClientMouseMovement : Position -> Position -> Model -> Model
handleClientMouseMovement newPosition priorPosition model =
    { model
        | drawAtRender =
            Draw.rectangle
                model.color.swatches.top
                priorPosition
                (adjustPosition model newPosition)
    }


handleClientMouseUp : Position -> Position -> Model -> Model
handleClientMouseUp newPosition priorPosition model =
    { model
        | tool = Rectangle Nothing
        , drawAtRender = Canvas.batch []
        , pendingDraw =
            [ model.pendingDraw
            , Draw.rectangle
                model.color.swatches.top
                priorPosition
                (adjustPosition model newPosition)
            ]
                |> Canvas.batch
    }
