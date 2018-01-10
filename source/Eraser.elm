module Eraser
    exposing
        ( handleClientMouseMovement
        , handleScreenMouseDown
        , view
        )

import Canvas exposing (DrawOp(..))
import Data.Tool exposing (Tool(Eraser))
import Draw
import Helpers.History as History
import Helpers.Tool exposing (adjustPosition)
import Html exposing (Html)
import Model exposing (Model)
import Mouse exposing (Position)


type alias State msg =
    { size : Int
    , increaseMsg : msg
    , decreaseMsg : msg
    }


view : State msg -> Html msg
view state =
    Html.text "DANK"


handleScreenMouseDown : Position -> Model -> Model
handleScreenMouseDown clientPos model =
    let
        position =
            adjustPosition model clientPos
    in
    { model
        | tool = Eraser (Just position)
        , pendingDraw =
            [ model.pendingDraw
            , Draw.eraserPoint
                model.color.swatches.primary
                model.eraserSize
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
        | tool = Eraser (Just adjustedPosition)
        , pendingDraw =
            [ model.pendingDraw
            , Draw.eraser
                model.color.swatches.primary
                model.eraserSize
                priorPosition
                adjustedPosition
            ]
                |> Canvas.batch
    }
