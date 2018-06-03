module Eraser
    exposing
        ( css
        , handleClientMouseMovement
        , handleClientMouseUp
        , handleScreenMouseDown
        , view
        )

import Canvas exposing (DrawOp(..))
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Tool exposing (Tool(Eraser))
import Draw
import Helpers.History as History
import Helpers.Tool
    exposing
        ( adjustPosition
        , getColor
        )
import Html exposing (Html, input)
import Html.Attributes exposing (value)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Model exposing (Model)
import Mouse exposing (Position)
import Mouse.Extra as Mouse


-- TYPES --


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


handleScreenMouseDown : Mouse.Position -> Mouse.Button -> Model -> Model
handleScreenMouseDown clientPos button model =
    let
        position =
            adjustPosition model clientPos
    in
    { model
        | tool =
            ( position, button )
                |> Just
                |> Eraser
        , pendingDraw =
            [ model.pendingDraw
            , Draw.eraserPoint
                (getColor button model.color.swatches)
                model.eraserSize
                position
            ]
                |> Canvas.batch
    }
        |> History.canvas


handleClientMouseMovement : Mouse.Position -> ( Mouse.Position, Mouse.Button ) -> Model -> Model
handleClientMouseMovement newPosition ( priorPosition, button ) model =
    let
        adjustedPosition =
            adjustPosition model newPosition
    in
    { model
        | tool =
            ( adjustedPosition, button )
                |> Just
                |> Eraser
        , pendingDraw =
            [ model.pendingDraw
            , Draw.eraser
                (getColor button model.color.swatches)
                model.eraserSize
                priorPosition
                adjustedPosition
            ]
                |> Canvas.batch
    }


handleClientMouseUp : Mouse.Position -> ( Mouse.Position, Mouse.Button ) -> Model -> Model
handleClientMouseUp newPosition ( priorPosition, button ) model =
    { model
        | tool = Eraser Nothing
        , drawAtRender = Canvas.batch []
        , pendingDraw =
            [ model.pendingDraw
            , Draw.eraser
                (getColor button model.color.swatches)
                model.eraserSize
                priorPosition
                (adjustPosition model newPosition)
            ]
                |> Canvas.batch
    }
