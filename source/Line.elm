module Line
    exposing
        ( handleClientMouseMovement
        , handleClientMouseUp
        , handleScreenMouseDown
        )

import Canvas exposing (Size)
import Data.Tool exposing (Tool(Line))
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
        | tool = Line (Just adjustedPosition)
        , drawAtRender =
            Draw.line
                model.color.swatches.primary
                adjustedPosition
                adjustedPosition
    }
        |> History.canvas


handleClientMouseMovement : Position -> Position -> Model -> Model
handleClientMouseMovement newPosition priorPosition model =
    { model
        | drawAtRender =
            Draw.line
                model.color.swatches.primary
                priorPosition
                (adjustPosition model newPosition)
    }


handleClientMouseUp : Position -> Position -> Model -> Model
handleClientMouseUp newPosition priorPosition model =
    { model
        | tool = Line Nothing
        , drawAtRender = Canvas.batch []
        , pendingDraw =
            [ model.pendingDraw
            , Draw.line
                model.color.swatches.primary
                priorPosition
                (adjustPosition model newPosition)
            ]
                |> Canvas.batch
    }
