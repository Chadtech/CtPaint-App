module Toolbar exposing (Msg(..), css, update, view)

import Canvas
import Chadtech.Colors exposing (ignorable2, ignorable3)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Tool exposing (Tool(..))
import Draw
import Eraser
import Helpers.Menu
import Html exposing (Html, a, div)
import Html.Attributes exposing (attribute, title)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Menu
import Model exposing (Model)
import Tool
import Tuple.Infix exposing ((&), (|&))


-- TYPES --


type Msg
    = ToolButtonClicked Tool
    | OtherButtonClicked OtherThing
    | IncreaseEraserClicked
    | DecreaseEraserClicked


type OtherThing
    = Text
    | Invert
    | Replace
    | Transparency



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        ToolButtonClicked tool ->
            { model | tool = tool } & Cmd.none

        OtherButtonClicked Text ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initText
                        |> Just
            }
                & Cmd.none

        OtherButtonClicked Invert ->
            case model.selection of
                Just ( position, selection ) ->
                    { model
                        | selection =
                            selection
                                |> Draw.invert
                                |& position
                                |> Just
                    }
                        & Cmd.none

                Nothing ->
                    { model
                        | canvas =
                            Draw.invert model.canvas
                    }
                        & Cmd.none

        OtherButtonClicked Replace ->
            Helpers.Menu.initReplaceColor model

        OtherButtonClicked Transparency ->
            case model.selection of
                Just ( pos, selection ) ->
                    { model
                        | selection =
                            selection
                                |> Canvas.transparentColor
                                    model.color.swatches.second
                                |& pos
                                |> Just
                    }
                        & Cmd.none

                Nothing ->
                    model & Cmd.none

        IncreaseEraserClicked ->
            if model.eraserSize < 9 then
                { model | eraserSize = model.eraserSize + 1 }
                    & Cmd.none
            else
                model & Cmd.none

        DecreaseEraserClicked ->
            if model.eraserSize < 2 then
                model & Cmd.none
            else
                { model | eraserSize = model.eraserSize - 1 }
                    & Cmd.none



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
    Html.Custom.makeNamespace "Toolbar"



-- VIEW --


{ class, classList } =
    Html.CssHelpers.withNamespace toolbarNamespace


view : Model -> Html Msg
view model =
    div
        [ class [ Toolbar ] ]
        (children model)



-- COMPONENTS --


children : Model -> List (Html Msg)
children model =
    [ List.map (toolButton model.tool) Tool.all
    , List.map otherButton otherThings
    , toolMenu model
    ]
        |> List.concat


toolMenu : Model -> List (Html Msg)
toolMenu model =
    case model.tool of
        Eraser _ ->
            { size = model.eraserSize
            , increaseMsg = IncreaseEraserClicked
            , decreaseMsg = DecreaseEraserClicked
            }
                |> Eraser.view

        _ ->
            []


otherThings : List ( String, String, OtherThing )
otherThings =
    [ ( "\xEA19", "text", Text )
    , ( "\xEA0F", "replace color", Replace )
    , ( "\xEA0E", "invert colors", Invert )
    , ( "\xEA12", "transparency", Transparency )
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
