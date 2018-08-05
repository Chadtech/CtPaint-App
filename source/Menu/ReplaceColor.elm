module Menu.ReplaceColor exposing (..)

import Chadtech.Colors as Ct
import Color exposing (Color)
import Color.Util
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Taco exposing (Taco)
import Html exposing (Html, a, div, input, p, text)
import Html.Attributes exposing (spellcheck, value)
import Html.CssHelpers
import Html.Custom exposing (indent)
import Html.Events exposing (onClick, onInput)
import Menu.Reply exposing (Reply(Replace))
import Return2 as R2
import Return3 as R3 exposing (Return)


-- TYPES --


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


update : Taco -> Msg -> Model -> Return Model Msg Reply
update taco msg model =
    case msg of
        ReplaceButtonClicked ->
            model
                |> R2.withNoCmd
                |> R3.withReply
                    (Replace model.target model.replacement)

        SquareClicked Replacement index color ->
            { model
                | replacement = color
                , replacementPaletteIndex = Just index
                , replacementHexField =
                    color
                        |> Color.Util.toHexString
                        |> String.dropLeft 1
            }
                |> R2.withNoCmd
                |> R3.withNoReply

        SquareClicked Target index color ->
            { model
                | target = color
                , targetPaletteIndex = Just index
                , targetHexField =
                    color
                        |> Color.Util.toHexString
                        |> String.dropLeft 1
            }
                |> R2.withNoCmd
                |> R3.withNoReply

        UpdateHexField Replacement str ->
            { model
                | replacementHexField = String.toUpper str
                , replacementPaletteIndex = Nothing
            }
                |> cohereReplacementColor
                |> R3.withNothing

        UpdateHexField Target str ->
            { model
                | targetHexField = String.toUpper str
                , targetPaletteIndex = Nothing
            }
                |> cohereTargetColor
                |> R3.withNothing


cohereReplacementColor : Model -> Model
cohereReplacementColor model =
    case Color.Util.fromString model.replacementHexField of
        Just color ->
            { model | replacement = color }

        Nothing ->
            model


cohereTargetColor : Model -> Model
cohereTargetColor model =
    case Color.Util.fromString model.targetHexField of
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
        , backgroundColor Ct.background2
        ]
    , Css.class Square
        [ borderLeft3 (px 1) solid Ct.ignorable3
        , borderTop3 (px 1) solid Ct.ignorable3
        , borderRight3 (px 1) solid Ct.ignorable1
        , borderBottom3 (px 1) solid Ct.ignorable1
        , height (px 20)
        , width (px 20)
        , float left
        , withClass Selected
            [ borderLeft3 (px 2) solid Ct.ignorable0
            , borderTop3 (px 2) solid Ct.ignorable0
            , borderRight3 (px 2) solid Ct.ignorable0
            , borderBottom3 (px 2) solid Ct.ignorable0
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


view : Model -> Html Msg
view model =
    [ targetSide model
    , replacementSide model
    , Html.Custom.menuButton
        [ class [ ReplaceButton ]
        , onClick ReplaceButtonClicked
        ]
        [ Html.text "replace" ]
    ]
        |> Html.Custom.cardBody []


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
        , Color.Util.background color
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
        , Color.Util.background color
        ]
        []



-- INIT --


init : Color.Color -> Color.Color -> List Color.Color -> Model
init target replacement palette =
    { target = target
    , replacement = replacement
    , targetHexField =
        target
            |> Color.Util.toHexString
            |> String.dropLeft 1
    , replacementHexField =
        replacement
            |> Color.Util.toHexString
            |> String.dropLeft 1
    , targetPaletteIndex = Just 0
    , replacementPaletteIndex = Just 2
    , palette = palette
    }
