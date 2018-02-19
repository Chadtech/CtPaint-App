module Pencil
    exposing
        ( handleClientMouseMovement
        , handleScreenMouseDown
        )

import Canvas exposing (DrawOp(..))
import Data.Tool exposing (Tool(Pencil))
import Draw
import Helpers.History as History
import Helpers.Tool exposing (adjustPosition)
import Model exposing (Model)
import Mouse exposing (Position)


handleScreenMouseDown : Position -> Model -> Model
handleScreenMouseDown clientPos model =
    let
        position =
            adjustPosition model clientPos
    in
    { model
        | tool = Pencil (Just position)
        , pendingDraw =
            [ model.pendingDraw
            , Draw.line
                model.color.swatches.top
                position
                position
            ]
                |> Canvas.batch
    }
        |> History.canvas


handleClientMouseMovement : Position -> Position -> Model -> Model
handleClientMouseMovement newPosition priorPosition model =
    let
        adjustedPosition =
            adjustPosition model newPosition
    in
    { model
        | tool = Pencil (Just adjustedPosition)
        , pendingDraw =
            [ model.pendingDraw
            , Draw.line
                model.color.swatches.top
                priorPosition
                adjustedPosition
            ]
                |> Canvas.batch
    }
