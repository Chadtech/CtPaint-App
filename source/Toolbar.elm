module Toolbar exposing (Msg(..), css, update, view)

import Canvas
import Chadtech.Colors exposing (ignorable2, ignorable3)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Selection as Selection
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
import Ports
import Return2 as R2
import Tool
import Tracking
    exposing
        ( Event
            ( ToolbarDecreaseEraserClick
            , ToolbarIncreaseEraserClick
            , ToolbarOtherButtonClick
            , ToolbarToolButtonClick
            )
        )


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
            tool
                |> Tool.name
                |> ToolbarToolButtonClick
                |> Ports.track model.taco
                |> R2.withModel
                    { model | tool = tool }

        OtherButtonClicked otherThing ->
            handleOtherButtonClick otherThing model
                |> R2.addCmd
                    (trackOtherButtonClick otherThing model)

        IncreaseEraserClicked ->
            model
                |> increaseEraser
                |> R2.withNoCmd

        DecreaseEraserClicked ->
            model
                |> decreaseEraser
                |> R2.withNoCmd


trackOtherButtonClick : OtherThing -> Model -> Cmd msg
trackOtherButtonClick otherThing model =
    otherThing
        |> toString
        |> String.toLower
        |> ToolbarOtherButtonClick
        |> Ports.track model.taco


handleOtherButtonClick : OtherThing -> Model -> ( Model, Cmd msg )
handleOtherButtonClick otherThing model =
    case otherThing of
        Text ->
            { model
                | menu =
                    model.windowSize
                        |> Menu.initText
                        |> Just
            }
                |> R2.withCmd Ports.stealFocus

        Invert ->
            case model.selection of
                Just selection ->
                    { model
                        | selection =
                            Selection.updateCanvas
                                Draw.invert
                                selection
                                |> Just
                    }
                        |> R2.withNoCmd

                Nothing ->
                    { model
                        | canvas =
                            Draw.invert model.canvas
                    }
                        |> R2.withNoCmd

        Replace ->
            Helpers.Menu.initReplaceColor model

        Transparency ->
            case model.selection of
                Just selection ->
                    { model
                        | selection =
                            Selection.updateCanvas
                                (Canvas.transparentColor model.color.swatches.bottom)
                                selection
                                |> Just
                    }
                        |> R2.withNoCmd

                Nothing ->
                    model
                        |> R2.withNoCmd


increaseEraser : Model -> Model
increaseEraser model =
    if model.eraserSize < 9 then
        { model | eraserSize = model.eraserSize + 1 }
    else
        model


decreaseEraser : Model -> Model
decreaseEraser model =
    if model.eraserSize < 2 then
        model
    else
        { model | eraserSize = model.eraserSize - 1 }



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
