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
                |> RectangleFilled
        , drawAtRender =
            Draw.filledRectangle
                (getColor button model.color.swatches)
                (Size 1 1)
                adjustedPosition
    }
        |> History.canvas


handleClientMouseMovement : Position -> ( Position, Mouse.Button ) -> Model -> Model
handleClientMouseMovement newPosition ( priorPosition, button ) model =
    let
        ( drawPosition, size ) =
            makeRectParams
                (adjustPosition model newPosition)
                priorPosition
    in
    { model
        | drawAtRender =
            Draw.filledRectangle
                (getColor button model.color.swatches)
                size
                drawPosition
    }


handleClientMouseUp : Position -> ( Position, Mouse.Button ) -> Model -> Model
handleClientMouseUp newPosition ( priorPosition, button ) model =
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
                (getColor button model.color.swatches)
                size
                drawPosition
            ]
                |> Canvas.batch
    }
