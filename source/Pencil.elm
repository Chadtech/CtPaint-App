module Pencil
    exposing
        ( handleClientMouseMovement
        , handleScreenMouseDown
        )

import Canvas exposing (DrawOp(..))
import Data.Tool exposing (Tool(Pencil))
import Draw
import Helpers.History as History
import Helpers.Tool
    exposing
        ( adjustPosition
        , getColor
        )
import Model exposing (Model)
import Mouse exposing (Position)
import Mouse.Extra as Mouse


handleScreenMouseDown : Position -> Mouse.Button -> Model -> Model
handleScreenMouseDown clientPos button model =
    let
        position =
            adjustPosition model clientPos
    in
    { model
        | tool =
            ( position, button )
                |> Just
                |> Pencil
        , pendingDraw =
            [ model.pendingDraw
            , Draw.line
                (getColor button model.color.swatches)
                position
                position
            ]
                |> Canvas.batch
    }
        |> History.canvas


handleClientMouseMovement : Position -> ( Position, Mouse.Button ) -> Model -> Model
handleClientMouseMovement newPosition ( priorPosition, button ) model =
    let
        adjustedPosition =
            adjustPosition model newPosition
    in
    { model
        | tool =
            ( adjustedPosition, button )
                |> Just
                |> Pencil
        , pendingDraw =
            [ model.pendingDraw
            , Draw.line
                (getColor button model.color.swatches)
                priorPosition
                adjustedPosition
            ]
                |> Canvas.batch
    }
