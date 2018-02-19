module Eraser
    exposing
        ( css
        , handleClientMouseMovement
        , handleScreenMouseDown
        , view
        )

import Canvas exposing (DrawOp(..))
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Tool exposing (Tool(Eraser))
import Draw
import Helpers.History as History
import Helpers.Tool exposing (adjustPosition)
import Html exposing (Html, input)
import Html.Attributes exposing (value)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Model exposing (Model)
import Mouse exposing (Position)


type alias State msg =
    { size : Int
    , increaseMsg : msg
    , decreaseMsg : msg
    }



-- STYLES --


type Class
    = Plus
    | Button
    | Field


css : Stylesheet
css =
    [ Css.class Plus
        [ marginTop (px 24) ]
    , Css.class Button
        [ lineHeight (px 23)
        , marginBottom (px 1)
        ]
    , Css.class Field
        [ display block
        , width (px 24)
        , marginBottom (px 1)
        ]
    ]
        |> namespace eraserNamespace
        |> stylesheet


eraserNamespace : String
eraserNamespace =
    Html.Custom.makeNamespace "Eraser"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace eraserNamespace


view : State msg -> List (Html msg)
view { increaseMsg, decreaseMsg, size } =
    [ Html.Custom.toolbarButton
        { text = "+"
        , selected = False
        , attrs =
            [ class [ Plus, Button ]
            , onClick increaseMsg
            ]
        }
    , input
        [ class [ Field ]
        , value (toString size)
        ]
        []
    , Html.Custom.toolbarButton
        { text = "-"
        , selected = False
        , attrs =
            [ class [ Button ]
            , onClick decreaseMsg
            ]
        }
    ]


handleScreenMouseDown : Mouse.Position -> Model -> Model
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
                model.color.swatches.top
                model.eraserSize
                position
            ]
                |> Canvas.batch
    }
        |> History.canvas


handleClientMouseMovement : Mouse.Position -> Mouse.Position -> Model -> Model
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
                model.color.swatches.top
                model.eraserSize
                priorPosition
                adjustedPosition
            ]
                |> Canvas.batch
    }
