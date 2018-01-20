module ReplaceColor exposing (..)

import Chadtech.Colors
    exposing
        ( backgroundx2
        , ignorable0
        , ignorable1
        , ignorable3
        )
import Color exposing (Color)
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Html exposing (Html, a, div, input, p, text)
import Html.Attributes exposing (spellcheck, value)
import Html.CssHelpers
import Html.Custom exposing (indent)
import Html.Events exposing (onClick, onInput)
import Reply exposing (Reply(NoReply, Replace))
import Tuple.Infix exposing ((&))
import Util


type Msg
    = ReplaceButtonClicked
    | SquareClicked Color.Color
    | UpdateReplacementHexField String
    | UpdateTargetHexField String


type alias Model =
    { target : Color.Color
    , replacement : Color.Color
    , targetHexField : String
    , replacementHexField : String
    , targetPaletteIndex : Maybe Int
    , replacementPaletteIndex : Maybe Int
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

        UpdateReplacementHexField str ->
            model & NoReply

        UpdateTargetHexField str ->
            model & NoReply



-- STYLES --


type Class
    = Row
    | Palette
    | Square
    | ColorView
    | ReplaceButton
    | Section
    | With
    | HexField
    | Selected


css : Stylesheet
css =
    [ Css.class Row
        [ height (px 24)
        , marginBottom (px 4)
        , children
            [ Css.Elements.p
                [ verticalAlign top
                , display inlineBlock
                , width (px 90)
                ]
            ]
        ]
    , Css.class Section
        [ display inlineBlock
        , withClass With
            [ marginLeft (px 8) ]
        ]
    , (Css.class ColorView << List.append indent)
        [ display inlineBlock
        , width (px 102)
        , height (px 20)
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
        , withClass Selected
            [ borderLeft3 (px 2) solid ignorable0
            , borderTop3 (px 2) solid ignorable0
            , borderRight3 (px 2) solid ignorable0
            , borderBottom3 (px 2) solid ignorable0
            , height (px 18)
            , width (px 18)
            ]
        ]
    , Css.class ReplaceButton
        [ marginTop (px 8) ]
    , Css.class HexField
        [ width (px 70)
        , marginLeft (px 4)
        , position absolute
        ]
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
    [ replaceSide model
    , withSide model
    , Html.Custom.menuButton
        [ class [ ReplaceButton ]
        , onClick ReplaceButtonClicked
        ]
        [ Html.text "replace" ]
    ]


replaceSide : Model -> Html Msg
replaceSide { targetHexField, target, palette, targetPaletteIndex } =
    div
        [ class [ Section ] ]
        [ div
            [ class [ Row ] ]
            [ p [] [ Html.text "replace" ] ]
        , div
            [ class [ Row ] ]
            [ colorView target
            , input
                [ spellcheck False
                , onInput UpdateTargetHexField
                , value targetHexField
                , class [ HexField ]
                ]
                []
            ]
        , div
            [ class [ Palette ] ]
            (squares targetPaletteIndex palette)
        ]


withSide : Model -> Html Msg
withSide model =
    div
        [ class [ Section, With ] ]
        [ div
            [ class [ Row ] ]
            [ p [] [ Html.text "with" ] ]
        , div
            [ class [ Row ] ]
            [ colorView model.replacement
            , input
                [ spellcheck False
                , onInput UpdateReplacementHexField
                , value model.replacementHexField
                , class [ HexField ]
                ]
                []
            ]
        , div
            [ class [ Palette ] ]
            (squares model.replacementPaletteIndex model.palette)
        ]


squares : Maybe Int -> List Color.Color -> List (Html Msg)
squares maybeIndex =
    List.indexedMap (square maybeIndex)


square : Maybe Int -> Int -> Color.Color -> Html Msg
square maybeSelected index color =
    div
        [ class (squareClass maybeSelected index)
        , onClick (SquareClicked color)
        , Util.background color
        ]
        []


squareClass : Maybe Int -> Int -> List Class
squareClass maybeSelected index =
    case maybeSelected of
        Just selectedIndex ->
            if selectedIndex == index then
                [ Square, Selected ]
            else
                [ Square ]

        Nothing ->
            [ Square ]


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
    , targetHexField =
        target
            |> Util.toHexColor
            |> String.dropLeft 1
    , replacementHexField =
        replacement
            |> Util.toHexColor
            |> String.dropLeft 1
    , targetPaletteIndex = Just 0
    , replacementPaletteIndex = Just 2
    , palette = palette
    }
