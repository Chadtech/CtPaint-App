module View exposing (css, view)

import Canvas exposing (Canvas)
import Chadtech.Colors exposing (ignorable2)
import ColorPicker
import Css exposing (..)
import Css.Elements exposing (canvas)
import Css.Namespace exposing (namespace)
import Data.Menu
import Data.Minimap exposing (State(..))
import Data.Tool
import Html exposing (Html, div)
import Html.Attributes as Attributes exposing (style)
import Html.CssHelpers
import Html.Events exposing (onMouseLeave)
import Menu
import Minimap
import Model exposing (Model)
import Mouse
import MouseEvents exposing (onMouseMove)
import Msg exposing (Msg(..))
import Palette
import Taskbar
import Tool
import Toolbar
import Util exposing (toolbarWidth)


-- STYLES --


type Class
    = Main
    | Gallery
    | CanvasArea
    | MainCanvas
    | SelectionCanvas
    | Screen
    | Hand
    | Sample
    | Fill
    | Select
    | ZoomIn
    | ZoomOut
    | Pencil
    | Line
    | Rectangle
    | RectangleFilled


css : Stylesheet
css =
    [ Css.class Main
        [ width (pct 100)
        , withClass Gallery
            [ cursor none
            , children
                [ canvas
                    [ display block
                    , margin2 zero auto
                    , transform (translateY (pct 50))
                    ]
                ]
            ]
        ]
    , Css.class MainCanvas
        [ position absolute
        , border3 (px 2) solid ignorable2
        ]
    , Css.class SelectionCanvas
        [ position absolute
        , backgroundImage (url "https://cdn.rawgit.com/Chadtech/CtPaint-Shell/master/public/selection.gif")
        , padding (px 1)
        ]
    , Css.class CanvasArea
        [ position absolute
        , overflow hidden
        , width (calc (pct 100) minus (px toolbarWidth))
        , left (px toolbarWidth)
        , top (px toolbarWidth)
        ]
    , Css.class Screen
        [ position absolute
        , width (calc (pct 100) minus (px toolbarWidth))
        , left (px toolbarWidth)
        , top (px toolbarWidth)
        , cursor crosshair
        , withClass Hand [ cursor move ]
        , textAlign center
        ]
    ]
        |> namespace mainViewNamespace
        |> stylesheet


mainViewNamespace : String
mainViewNamespace =
    "MainView"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace mainViewNamespace


view : Model -> Html Msg
view model =
    if model.galleryView then
        galleryView model
    else
        let
            canvasAreaHeight =
                [ model.windowSize.height
                , -model.horizontalToolbarHeight
                , -(floor toolbarWidth)
                ]
                    |> List.sum
        in
        div
            [ class [ Main ] ]
            [ Html.map ToolbarMsg (Toolbar.view model.tool)
            , Html.map TaskbarMsg (Taskbar.view model)
            , Html.map PaletteMsg (Palette.view model)
            , canvasArea canvasAreaHeight model
            , clickScreen canvasAreaHeight model
            , colorPicker model
            , minimap model
            , menu model.menu
            ]


galleryView : Model -> Html Msg
galleryView model =
    div
        [ class [ Main, Gallery ] ]
        [ Canvas.toHtml [] model.canvas ]



-- MENU --


menu : Maybe Data.Menu.Model -> Html Msg
menu maybeMenuModel =
    case maybeMenuModel of
        Just menuModel ->
            Html.map MenuMsg (Menu.view menuModel)

        Nothing ->
            Html.text ""



-- MINI MAP --


minimap : Model -> Html Msg
minimap model =
    case model.minimap of
        Opened minimapModel ->
            Minimap.view
                minimapModel
                model.canvas
                model.selection
                |> Html.map MinimapMsg

        _ ->
            Html.text ""



-- COLOR PICKER --


colorPicker : Model -> Html Msg
colorPicker { colorPicker } =
    if colorPicker.window.show then
        colorPicker
            |> ColorPicker.view
            |> Html.map ColorPickerMsg
    else
        Html.text ""



-- CLICK SCREEN --


clickScreen : Int -> Model -> Html Msg
clickScreen canvasAreaHeight model =
    let
        attributes =
            [ class [ Screen, toolClass model.tool ]
            , style [ Util.height canvasAreaHeight ]
            , onMouseLeave ScreenMouseExit
            , onMouseMove ScreenMouseMove
            ]

        toolAttrs =
            List.map
                (Attributes.map ToolMsg)
                (Tool.attributes model.tool)
    in
    div (toolAttrs ++ attributes) []


toolClass : Data.Tool.Tool -> Class
toolClass tool =
    case tool of
        Data.Tool.Hand _ ->
            Hand

        Data.Tool.Sample ->
            Sample

        Data.Tool.Fill ->
            Fill

        Data.Tool.Pencil _ ->
            Pencil

        Data.Tool.Line _ ->
            Line

        Data.Tool.Rectangle _ ->
            Rectangle

        Data.Tool.RectangleFilled _ ->
            RectangleFilled

        Data.Tool.Select _ ->
            Select

        Data.Tool.ZoomIn ->
            ZoomIn

        Data.Tool.ZoomOut ->
            ZoomOut



-- CANVAS --


canvasArea : Int -> Model -> Html Msg
canvasArea canvasAreaHeight model =
    div
        [ class [ CanvasArea ]
        , style
            [ Util.height canvasAreaHeight ]
        ]
        [ Canvas.toHtml
            [ class [ MainCanvas ]
            , Attributes.id "main-canvas"
            , style (canvasStyles model)
            ]
            (Canvas.draw model.drawAtRender model.canvas)
        , selection model
        ]


canvasStyles : Model -> List ( String, String )
canvasStyles { zoom, canvasPosition, canvas } =
    let
        canvasSize =
            Canvas.getSize canvas
    in
    [ Util.left canvasPosition.x
    , Util.top canvasPosition.y
    , Util.width (canvasSize.width * zoom)
    , Util.height (canvasSize.height * zoom)
    ]


selection : Model -> Html Msg
selection model =
    case model.selection of
        Just ( position, canvas ) ->
            div
                [ style (selectionStyles model position canvas) ]
                [ Canvas.toHtml
                    [ class [ SelectionCanvas ]
                    , style (selectionStyles model position canvas)
                    ]
                    canvas
                ]

        Nothing ->
            Html.text ""


selectionStyles : Model -> Mouse.Position -> Canvas -> List ( String, String )
selectionStyles { zoom, canvasPosition } position selection =
    let
        selectionSize =
            Canvas.getSize selection
    in
    [ Util.left (canvasPosition.x + position.x * zoom + 1)
    , Util.top (canvasPosition.y + position.y * zoom + 1)
    , Util.width (selectionSize.width * zoom)
    , Util.height (selectionSize.height * zoom)
    ]
