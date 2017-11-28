module ReplaceColor exposing (..)

import Chadtech.Colors
    exposing
        ( backgroundx2
        , ignorable1
        , ignorable3
        )
import Color exposing (Color)
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Html exposing (Html, a, div, p, text)
import Html.CssHelpers
import Html.Custom exposing (indent)
import Html.Events exposing (onClick)
import Reply exposing (Reply(NoReply, Replace))
import Tuple.Infix exposing ((&))
import Util


type Msg
    = ReplaceButtonClicked
    | SquareClicked Color.Color


type alias Model =
    { target : Color.Color
    , replacement : Color.Color
    , palette : List Color.Color
    }



-- UPDATE --


update : Msg -> Model -> ( Model, Reply )
update msg model =
    case msg of
        ReplaceButtonClicked ->
            model & Replace model.target model.replacement

        SquareClicked color ->
            { model | replacement = color }
                & NoReply



-- STYLES --


type Class
    = ColorRow
    | Palette
    | Square
    | ColorView
    | ReplaceButton


css : Stylesheet
css =
    [ Css.class ColorRow
        [ height (px 20)
        , marginBottom (px 4)
        , children
            [ Css.Elements.p
                [ verticalAlign top
                , display inlineBlock
                , width (px 90)
                ]
            ]
        ]
    , (Css.class ColorView << List.append indent)
        [ display inlineBlock
        , width (px 86)
        , height (px 16)
        ]
    , (Css.class Palette << List.append indent)
        [ width (px 176)
        , height (px 200)
        , overflowY auto
        , backgroundColor backgroundx2
        ]
    , Css.class Square
        [ borderLeft3 (px 1) solid ignorable3
        , borderTop3 (px 1) solid ignorable3
        , borderRight3 (px 1) solid ignorable1
        , borderBottom3 (px 1) solid ignorable1
        , height (px 20)
        , width (px 20)
        , float left
        ]
    , Css.class ReplaceButton
        [ marginTop (px 8) ]
    ]
        |> namespace replaceNamespace
        |> stylesheet


replaceNamespace : String
replaceNamespace =
    Html.Custom.makeNamespace "Replace"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace replaceNamespace


view : Model -> List (Html Msg)
view model =
    [ div
        [ class [ ColorRow ] ]
        [ p [] [ Html.text "replace" ]
        , colorView model.target
        ]
    , div
        [ class [ ColorRow ] ]
        [ p [] [ Html.text "with" ]
        , colorView model.replacement
        ]
    , div
        [ class [ Palette ] ]
        (squares model.palette)
    , Html.Custom.menuButton
        [ class [ ReplaceButton ]
        , onClick ReplaceButtonClicked
        ]
        [ Html.text "replace" ]
    ]


squares : List Color.Color -> List (Html Msg)
squares =
    List.map square


square : Color.Color -> Html Msg
square color =
    div
        [ class [ Square ]
        , onClick (SquareClicked color)
        , Util.background color
        ]
        []


colorView : Color.Color -> Html Msg
colorView color =
    div
        [ class [ ColorView ]
        , Util.background color
        ]
        []



-- INIT --


init : Color.Color -> Color.Color -> List Color.Color -> Model
init target replacement palette =
    { target = target
    , replacement = replacement
    , palette = palette
    }
