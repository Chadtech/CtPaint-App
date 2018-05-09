module Html.Custom
    exposing
        ( cannotSelect
        , card
        , cardBody
        , css
        , error
        , field
        , header
        , indent
        , makeNamespace
        , menuButton
        , outdent
        , spinner
        , textAreaStyle
        , toolButton
        , toolbarButton
        )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Elements exposing (a, body, canvas, form, p)
import Css.Namespace exposing (namespace)
import Html exposing (Attribute, Html)
import Html.Attributes
import Html.CssHelpers
import Html.Events
    exposing
        ( onMouseDown
        , onMouseUp
        )
import MouseEvents exposing (MouseEvent)
import Util exposing (def)


-- STYLES --


type Class
    = Field
    | Card
    | Submit
    | Body
    | Header
    | Selected
    | Long
    | Null
    | Error
    | SpinnerContainer
    | ToolButton
    | ToolButtonBase


css : Stylesheet
css =
    [ body
        [ backgroundColor Ct.background2
        , margin zero
        , padding zero
        ]
    , canvas
        [ property "image-rendering" "pixelated" ]
    , cardStyle
    , p <|
        List.append
            basicFont
            [ margin zero
            , padding zero
            ]
    , headerStyle
    , input
    , aStyle
    , submit
    , fieldStyle
    , form
        [ margin (px 0) ]
    , (Css.class ToolButton << List.append outdent)
        [ width (px 20)
        , height (px 20)
        , fontFamilies [ "HFICON" ]
        , fontSize (em 1)
        , textAlign center
        , padding (px 0)
        , lineHeight (px 20)
        , active indent
        , withClass Selected indent
        ]
    , (Css.class ToolButtonBase << List.append outdent)
        [ width (px 20)
        , height (px 20)
        , textAlign center
        , padding (px 0)
        , lineHeight (px 20)
        , active indent
        , withClass Selected indent
        ]
    , spinnerContainer
    , Css.class Error
        [ backgroundColor Ct.lowWarning
        , padding (px 8)
        ]
    ]
        |> namespace appNamespace
        |> stylesheet


textAreaStyle : List Style
textAreaStyle =
    [ outline none
    , fontFamilies [ "hfnss" ]
    , fontSize (em 2)
    , backgroundColor Ct.background2
    , color Ct.point0
    , width (px 486)
    , height (px 222)
    , marginBottom (px 8)
    , property "-webkit-font-smoothing" "none"
    , padding (px 8)
    , resize none
    ]
        ++ indent


appNamespace : String
appNamespace =
    "paintApp"


spinnerContainer : Snippet
spinnerContainer =
    [ position relative
    , backgroundColor Ct.background2
    , height (px 16)
    , overflow hidden
    , width (px 200)
    , margin auto
    ]
        |> List.append indent
        |> Css.class SpinnerContainer


fieldStyle : Snippet
fieldStyle =
    [ marginBottom (px 8)
    , children
        [ p
            [ display inlineBlock
            , width (px 120)
            , textAlign left
            , withClass Long
                [ width (px 180) ]
            ]
        ]
    ]
        |> Css.class Field


submit : Snippet
submit =
    [ margin auto
    , display table
    ]
        |> Css.class Submit


input : Snippet
input =
    [ backgroundColor Ct.background2
    , outline none
    , fontSize (em 2)
    , fontFamilies [ "hfnss" ]
    , color Ct.point0
    , property "-moz-osx-font-smoothing" "grayscale"
    , property "-webkit-font-smoothing" "none"
    , height (px 25)
    , lineHeight (px 19)
    , margin (px 0)
    , padding (px 0)
    , withClass Long
        [ width (px 300) ]
    ]
        |> List.append indent
        |> Css.Elements.input


headerStyle : Snippet
headerStyle =
    [ backgroundColor Ct.point0
    , height (px 25)
    , width (calc (pct 100) minus (px 8))
    , position absolute
    , padding (px 2)
    , margin (px 2)
    , lineHeight (px 25)
    , paddingLeft (px 2)
    , children
        [ p
            [ color Ct.ignorable3
            , cursor default
            , margin (px 0)
            , display inlineBlock
            , lineHeight (px 25)
            ]
        , a
            [ height (px 21)
            , width (px 21)
            , lineHeight (px 21)
            , padding (px 0)
            , float right
            , textAlign center
            ]
        ]
    ]
        |> Css.class Header


cardStyle : Snippet
cardStyle =
    [ backgroundColor Ct.ignorable2
    , borderTop3 (px 2) solid Ct.ignorable1
    , borderLeft3 (px 2) solid Ct.ignorable1
    , borderRight3 (px 2) solid Ct.ignorable3
    , borderBottom3 (px 2) solid Ct.ignorable3
    , children
        [ Css.class Body
            [ marginTop (px 31)
            , padding (px 8)
            , children
                []
            ]
        ]
    , textAlign left
    ]
        |> Css.class Card


aStyle : Snippet
aStyle =
    let
        mixins =
            [ outdent
            , [ active indent ]
            , basicFont
            , cannotSelect
            ]
                |> List.concat
    in
    [ textDecoration none
    , backgroundColor Ct.ignorable2
    , display inlineBlock
    , padding4 (px 4) (px 8) (px 4) (px 8)
    , cursor pointer
    , hover [ color Ct.point1 ]
    , withClass Selected indent
    , withClass Null
        [ backgroundColor Ct.ignorable1
        , hover [ color Ct.point0 ]
        , active outdent
        ]
    ]
        |> List.append mixins
        |> a


cannotSelect : List Style
cannotSelect =
    [ def "-webkit-user-select" "none"
    , def "-moz-user-select" "none"
    , def "-ms-user-select" "none"
    , def "user-select" "none"
    ]
        |> List.map (uncurry property)


indent : List Style
indent =
    [ borderTop3 (px 2) solid Ct.ignorable3
    , borderLeft3 (px 2) solid Ct.ignorable3
    , borderRight3 (px 2) solid Ct.ignorable1
    , borderBottom3 (px 2) solid Ct.ignorable1
    ]


outdent : List Style
outdent =
    [ borderTop3 (px 2) solid Ct.ignorable1
    , borderLeft3 (px 2) solid Ct.ignorable1
    , borderRight3 (px 2) solid Ct.ignorable3
    , borderBottom3 (px 2) solid Ct.ignorable3
    ]


basicFont : List Style
basicFont =
    [ fontFamilies [ "hfnss" ]
    , color Ct.point0
    , lineHeight (px 19)
    , property "-moz-osx-font-smoothing" "grayscale"
    , property "-webkit-font-smoothing" "none"
    , fontSize (px 32)
    ]


makeNamespace : String -> String
makeNamespace namespace =
    appNamespace ++ namespace



-- VIEW --


{ classList, class } =
    Html.CssHelpers.withNamespace appNamespace


menuButton : List (Attribute msg) -> List (Html msg) -> Html msg
menuButton attrs =
    Html.a (class [ Submit ] :: attrs)


field : List (Attribute msg) -> List (Html msg) -> Html msg
field attrs =
    Html.form (class [ Field ] :: attrs)


type alias ToolButtonState msg =
    { icon : String
    , selected : Bool
    , attrs : List (Html.Attribute msg)
    }


toolButton : ToolButtonState msg -> Html msg
toolButton state =
    Html.a (toolButtonAttrs state) [ Html.text state.icon ]


toolButtonAttrs : ToolButtonState msg -> List (Html.Attribute msg)
toolButtonAttrs state =
    classList
        [ def ToolButton True
        , def Selected state.selected
        ]
        :: state.attrs


type alias ToolbarButtonState msg =
    { text : String
    , selected : Bool
    , attrs : List (Html.Attribute msg)
    }


toolbarButton : ToolbarButtonState msg -> Html msg
toolbarButton state =
    let
        attrs =
            classList
                [ def ToolButtonBase True
                , def Selected state.selected
                ]
                :: state.attrs
    in
    Html.a attrs [ Html.text state.text ]


card : List (Attribute msg) -> List (Html msg) -> Html msg
card attrs =
    Html.div (class [ Card ] :: attrs)


cardBody : List (Attribute msg) -> List (Html msg) -> Html msg
cardBody attrs =
    Html.div (class [ Body ] :: attrs)


type alias HeaderState msg =
    { text : String
    , headerMouseDown : MouseEvent -> msg
    , xButtonMouseDown : msg
    , xButtonMouseUp : msg
    }


header : HeaderState msg -> Html msg
header { text, headerMouseDown, xButtonMouseDown, xButtonMouseUp } =
    Html.div
        [ class [ Header ]
        , MouseEvents.onMouseDown headerMouseDown
        ]
        [ Html.p [] [ Html.text text ]
        , Html.a
            [ onMouseUp xButtonMouseUp
            , onMouseDown xButtonMouseDown
            ]
            [ Html.text "x" ]
        ]


spinner : List (Attribute msg) -> Html msg
spinner attrs =
    Html.div
        (class [ SpinnerContainer ] :: attrs)
        [ Html.div
            [ Html.Attributes.class "spinner" ]
            []
        ]


error : List (Attribute msg) -> String -> Html msg
error attrs errMsg =
    Html.div
        (class [ Error ] :: attrs)
        [ Html.p
            []
            [ Html.text errMsg ]
        ]
