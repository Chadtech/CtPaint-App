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
        adjustedPosition =
            adjustPosition model clientPos
    in
    { model
        | tool =
            ( adjustedPosition, button )
                |> Just
                |> Rectangle
        , drawAtRender =
            Draw.rectangle
                (getColor button model.color.swatches)
                adjustedPosition
                adjustedPosition
    }
        |> History.canvas


handleClientMouseMovement : Position -> ( Position, Mouse.Button ) -> Model -> Model
handleClientMouseMovement newPosition ( priorPosition, button ) model =
    { model
        | drawAtRender =
            Draw.rectangle
                (getColor button model.color.swatches)
                priorPosition
                (adjustPosition model newPosition)
    }


handleClientMouseUp : Position -> ( Position, Mouse.Button ) -> Model -> Model
handleClientMouseUp newPosition ( priorPosition, button ) model =
    { model
        | tool = Rectangle Nothing
        , drawAtRender = Canvas.batch []
        , pendingDraw =
            [ model.pendingDraw
            , Draw.rectangle
                (getColor button model.color.swatches)
                priorPosition
                (adjustPosition model newPosition)
            ]
                |> Canvas.batch
    }
