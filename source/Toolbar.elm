module Toolbar exposing (Msg(..), css, view)

import Chadtech.Colors exposing (ignorable2, ignorable3)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, a, div)
import Html.Attributes exposing (attribute, title)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Tool exposing (Tool(..))
import Tuple.Infix exposing ((&))
import Types exposing (Model, Op(..))


-- TYPES --


type Msg
    = ToolButtonClicked Tool
    | MenuButtonClicked Op



-- STYLES --


type Class
    = Toolbar
    | Button


css : Stylesheet
css =
    [ Css.class Toolbar
        [ backgroundColor ignorable2
        , height (calc (pct 100) minus (px 30))
        , borderRight3 (px 1) solid ignorable3
        , paddingTop (px 30)
        , paddingLeft (px 2)
        , paddingRight (px 2)
        , top (px 0)
        , left (px 0)
        , maxWidth fitContent
        ]
    , Css.class Button
        [ display block
        , marginBottom (px 1)
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


menus : List ( String, String, Op )
menus =
    [ ( "\xEA19", "text", InitText )
    , ( "\xEA0F", "replace color", InitReplaceColor )
    , ( "\xEA0E", "invert colors", InvertColors )
    ]


menuButton : ( String, String, Op ) -> Html Msg
menuButton ( icon, name, op ) =
    { icon = icon
    , selected = False
    , attrs =
        [ onClick (MenuButtonClicked op)
        , attribute "data-toggle" "tooltip"
        , title name
        , class [ Button ]
        ]
    }
        |> Html.Custom.toolButton


toolButton : Tool -> Tool -> Html Msg
toolButton selectedTool tool =
    { icon = Tool.icon tool
    , selected = isSelectedTool selectedTool tool
    , attrs =
        [ attribute "data-toggle" "tooltip"
        , title (Tool.name tool)
        , onClick (ToolButtonClicked tool)
        , class [ Button ]
        ]
    }
        |> Html.Custom.toolButton



-- HELPERS --


isSelectedTool : Tool -> Tool -> Bool
isSelectedTool currentTool tool =
    Tool.name currentTool == Tool.name tool
