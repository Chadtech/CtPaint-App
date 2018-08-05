module Toolbar
    exposing
        ( Msg(..)
        , css
        , update
        , view
        )

import Canvas
import Chadtech.Colors exposing (ignorable2, ignorable3)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Draw
import Html exposing (Html, a, div)
import Html.Attributes exposing (attribute, title)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick)
import Menu.Model as Menu
import Model exposing (Model)
import Ports
import Return2 as R2
import Selection.Model as Selection
import Tool.Data as Tool exposing (Tool(..))
import Tool.Eraser as Eraser


-- TYPES --


type Msg
    = ToolButtonClicked Tool
    | OtherButtonClicked OtherButton
    | IncreaseEraserClicked
    | DecreaseEraserClicked


type OtherButton
    = Text
    | Invert
    | Replace
    | Transparency



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        ToolButtonClicked tool ->
            { model | tool = tool }
                |> R2.withNoCmd

        OtherButtonClicked otherButton ->
            handleOtherButtonClick otherButton model

        IncreaseEraserClicked ->
            model
                |> increaseEraser
                |> R2.withNoCmd

        DecreaseEraserClicked ->
            model
                |> decreaseEraser
                |> R2.withNoCmd


handleOtherButtonClick : OtherButton -> Model -> ( Model, Cmd msg )
handleOtherButtonClick otherButton model =
    case otherButton of
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
                            Selection.mapCanvas
                                Draw.invert
                                selection
                                |> Just
                    }
                        |> R2.withNoCmd

                Nothing ->
                    Model.mapMainCanvas
                        Draw.invert
                        model
                        |> R2.withNoCmd

        Replace ->
            Model.initReplaceColorMenu model

        Transparency ->
            case model.selection of
                Just selection ->
                    { model
                        | selection =
                            Selection.mapCanvas
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
        , property "width" "-moz-fit-content"
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
    [ List.map (toolButtonView model.tool) Tool.all
    , List.map otherButtonView otherButtons
    , toolMenu model
    ]
        |> List.concat
        |> div [ class [ Toolbar ] ]


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


otherButtons : List ( String, String, OtherButton )
otherButtons =
    [ ( "\xEA19", "text", Text )
    , ( "\xEA0F", "replace color", Replace )
    , ( "\xEA0E", "invert colors", Invert )
    , ( "\xEA12", "transparency", Transparency )
    ]


otherButtonView : ( String, String, OtherButton ) -> Html Msg
otherButtonView ( icon, name, otherButton ) =
    { icon = icon
    , selected = False
    , attrs =
        [ onClick (OtherButtonClicked otherButton)
        , attribute "data-toggle" "tooltip"
        , title name
        , class [ Button ]
        ]
    }
        |> Html.Custom.toolButton


toolButtonView : Tool -> Tool -> Html Msg
toolButtonView selectedTool tool =
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
