module Tool.Eraser
    exposing
        ( css
        , handleClientMouseMovement
        , handleClientMouseUp
        , handleScreenMouseDown
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Draw
import Draw.Model
import History.Helpers as History
import Html exposing (Html, input)
import Html.Attributes exposing (value)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Model exposing (Model)
import Mouse exposing (Position)
import Mouse.Extra as Mouse
import Position.Helpers
import Tool.Data exposing (Tool(Eraser))
import Tool.Helpers exposing (getColor)


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
            Position.Helpers.onCanvas model clientPos
    in
    { model
        | tool =
            ( position, button )
                |> Just
                |> Eraser
        , draws =
            Draw.eraserPoint
                (getColor button model.color.swatches)
                model.eraserSize
                position
                |> Draw.Model.addToPending
                |> Draw.Model.applyTo model.draws
    }
        |> History.canvas


handleClientMouseMovement : Mouse.Position -> ( Mouse.Position, Mouse.Button ) -> Model -> Model
handleClientMouseMovement newPosition ( priorPosition, button ) model =
    let
        adjustedPosition =
            Position.Helpers.onCanvas model newPosition
    in
    { model
        | tool =
            ( adjustedPosition, button )
                |> Just
                |> Eraser
        , draws =
            Draw.eraser
                (getColor button model.color.swatches)
                model.eraserSize
                priorPosition
                adjustedPosition
                |> Draw.Model.addToPending
                |> Draw.Model.applyTo model.draws
    }


handleClientMouseUp : Mouse.Position -> ( Mouse.Position, Mouse.Button ) -> Model -> Model
handleClientMouseUp newPosition ( priorPosition, button ) model =
    { model
        | tool = Eraser Nothing
        , draws =
            Draw.eraser
                (getColor button model.color.swatches)
                model.eraserSize
                priorPosition
                (Position.Helpers.onCanvas model newPosition)
                |> Draw.Model.addToPending
                |> Draw.Model.applyTo model.draws
                |> Draw.Model.clearAtRender
    }
