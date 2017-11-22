module Toolbar exposing (Msg(..), css, update, view)

import Chadtech.Colors exposing (ignorable2, ignorable3)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Tool exposing (Tool(..))
import Helpers.Menu
import Html exposing (Html, a, div)
import Html.Attributes exposing (attribute, title)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Menu
import Model exposing (Model)
import Tool


-- TYPES --


type Msg
    = ToolButtonClicked Tool
    | OtherButtonClicked OtherThing


type OtherThing
    = Text
    | Invert
    | Replace



-- UPDATE --


update : Msg -> Model -> Model
update msg model =
    case msg of
        ToolButtonClicked tool ->
            { model | tool = tool }

        OtherButtonClicked Text ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initText
                        |> Just
            }

        OtherButtonClicked Invert ->
            model

        OtherButtonClicked Replace ->
            Helpers.Menu.initReplaceColor model



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
    , List.map otherButton otherThings
    ]
        |> List.concat


otherThings : List ( String, String, OtherThing )
otherThings =
    [ ( "\xEA19", "text", Text )
    , ( "\xEA0F", "replace color", Replace )
    , ( "\xEA0E", "invert colors", Invert )
    ]


otherButton : ( String, String, OtherThing ) -> Html Msg
otherButton ( icon, name, otherThing ) =
    { icon = icon
    , selected = False
    , attrs =
        [ onClick (OtherButtonClicked otherThing)
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
