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
    | SquareClicked Side Int Color.Color
    | UpdateHexField Side String


type Side
    = Target
    | Replacement


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

        SquareClicked Replacement index color ->
            { model
                | replacement = color
                , replacementPaletteIndex = Just index
                , replacementHexField =
                    color
                        |> Util.toHexColor
                        |> String.dropLeft 1
            }
                & NoReply

        SquareClicked Target index color ->
            { model
                | target = color
                , targetPaletteIndex = Just index
                , targetHexField =
                    color
                        |> Util.toHexColor
                        |> String.dropLeft 1
            }
                & NoReply

        UpdateHexField Replacement str ->
            { model
                | replacementHexField = String.toUpper str
                , replacementPaletteIndex = Nothing
            }
                |> cohereReplacementColor
                & NoReply

        UpdateHexField Target str ->
            { model
                | targetHexField = String.toUpper str
                , targetPaletteIndex = Nothing
            }
                |> cohereTargetColor
                & NoReply


cohereReplacementColor : Model -> Model
cohereReplacementColor model =
    case Util.toColor model.replacementHexField of
        Just color ->
            { model | replacement = color }

        Nothing ->
            model


cohereTargetColor : Model -> Model
cohereTargetColor model =
    case Util.toColor model.targetHexField of
        Just color ->
            { model | target = color }

        Nothing ->
            model



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
    [ targetSide model
    , replacementSide model
    , Html.Custom.menuButton
        [ class [ ReplaceButton ]
        , onClick ReplaceButtonClicked
        ]
        [ Html.text "replace" ]
    ]


targetSide : Model -> Html Msg
targetSide { targetHexField, target, palette, targetPaletteIndex } =
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
                , onInput (UpdateHexField Target)
                , value targetHexField
                , class [ HexField ]
                ]
                []
            ]
        , div
            [ class [ Palette ] ]
            (squares Target targetPaletteIndex palette)
        ]


replacementSide : Model -> Html Msg
replacementSide model =
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
                , onInput (UpdateHexField Replacement)
                , value model.replacementHexField
                , class [ HexField ]
                ]
                []
            ]
        , model.palette
            |> squares
                Replacement
                model.replacementPaletteIndex
            |> div [ class [ Palette ] ]
        ]


squares : Side -> Maybe Int -> List Color.Color -> List (Html Msg)
squares side maybeIndex =
    List.indexedMap (square side maybeIndex)


square : Side -> Maybe Int -> Int -> Color.Color -> Html Msg
square side maybeSelected index color =
    div
        [ class (squareClass maybeSelected index)
        , onClick (SquareClicked side index color)
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
