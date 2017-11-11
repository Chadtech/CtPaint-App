module Toolbar exposing (css, view)

import Chadtech.Colors exposing (ignorable2, ignorable3)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, a, div)
import Html.Attributes exposing (attribute, title)
import Html.CssHelpers
import Html.Custom exposing (indent, outdent)
import Html.Events exposing (onClick)
import Tool exposing (Tool(..))
import Tuple.Infix exposing ((:=))
import Types exposing (Command(..), Model, Msg(..))
import Util exposing (toolbarWidth)


-- STYLES --


type Class
    = Toolbar
    | ToolButton
    | Selected


css : Stylesheet
css =
    [ Css.class Toolbar
        [ backgroundColor ignorable2
        , height (calc (pct 100) minus (px 30))
        , borderRight3 (px 1) solid ignorable3
        , paddingTop (px 30)
        , top (px 0)
        , left (px 0)
        , width (px toolbarWidth)
        ]
    , (Css.class ToolButton << List.append outdent)
        [ width (px 20)
        , height (px 20)
        , fontFamilies [ "icons" ]
        , fontSize (em 1)
        , textAlign center
        , padding (px 0)
        , lineHeight (px 20)
        , marginLeft (px 2)
        , active indent
        , withClass Selected indent
        ]
    ]
        |> namespace toolbarNamespace
        |> stylesheet


toolbarNamespace : String
toolbarNamespace =
    "Toolbar"



-- VIEW --


{ class, classList } =
    Html.CssHelpers.withNamespace toolbarNamespace


view : Tool -> Html Msg
view tool =
    div
        [ class [ Toolbar ] ]
        (children tool)



-- COMPONENTS --


children : Tool -> List (Html Msg)
children currentTool =
    [ List.map (toolButton currentTool) Tool.all
    , List.map menuButton menus
    ]
        |> List.concat


menus : List ( String, String, Command )
menus =
    [ ( "\xEA19", "text", InitText )
    , ( "\xEA0F", "replace color", InitReplaceColor )
    , ( "\xEA0E", "invert colors", InvertColors )
    ]


menuButton : ( String, String, Command ) -> Html Msg
menuButton ( icon, name, command ) =
    a
        [ class [ ToolButton ]
        , onClick (Command command)
        , attribute "data-toggle" "tooltip"
        , title name
        ]
        [ Html.text icon ]


toolButton : Tool -> Tool -> Html Msg
toolButton selectedTool tool =
    a
        [ classList
            [ ToolButton := True
            , Selected
                := isSelectedTool selectedTool tool
            ]
        , attribute "data-toggle" "tooltip"
        , title (Tool.name tool)
        , onClick (SetTool tool)
        ]
        [ Html.text (Tool.icon tool) ]



-- HELPERS --


isSelectedTool : Tool -> Tool -> Bool
isSelectedTool currentTool tool =
    Tool.name currentTool == Tool.name tool
