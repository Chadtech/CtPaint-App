module View exposing (css, view)

import Canvas exposing (Canvas, DrawOp)
import Chadtech.Colors
    exposing
        ( backgroundx2
        , ignorable1
        , ignorable2
        )
import Color
import ColorPicker
import Css exposing (..)
import Css.Elements exposing (canvas)
import Css.Namespace exposing (namespace)
import Data.Menu
import Data.Minimap exposing (State(..))
import Data.Tool
import Draw
import Html exposing (Html, div, input, p, span)
import Html.Attributes as Attributes exposing (style)
import Html.CssHelpers
import Html.Custom exposing (indent)
import Html.Events exposing (on, onMouseLeave)
import Html.Lazy
import Menu
import Minimap
import Model exposing (Model)
import Mouse
import MouseEvents
    exposing
        ( onMouseDown
        , onMouseMove
        , onMouseUp
        )
import Msg exposing (Msg(..))
import Palette
import Taskbar
import Toolbar
import Tuple.Infix exposing ((:=))
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
    | Ellipse
    | Info
    | Edge
    | Palette


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
        , backgroundImage (url "./selection.gif")
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
        , withClass Hand
            [ cursor move ]
        , withClass ZoomIn
            [ property "cursor" "-webkit-zoom-in" ]
        , withClass ZoomOut
            [ property "cursor" "-webkit-zoom-out" ]
        , textAlign center
        ]
    , Css.class Palette
        [ backgroundColor ignorable2
        , position fixed
        , bottom (px 0)
        , left (px toolbarWidth)
        , width (calc (pct 100) minus (px 29))
        ]
    , Css.class Edge
        [ height (px 3)
        , borderTop3 (px 2) solid ignorable1
        , top (px 0)
        , left (px 0)
        , cursor nsResize
        ]
    , (Css.class Info << List.append indent)
        [ backgroundColor backgroundx2
        , width (px 290)
        , position absolute
        , left (calc (pct 100) minus (px 297))
        , top (px 4)
        , overflowY auto
        , children
            [ Css.Elements.p
                [ float left
                , marginRight (px 8)
                ]
            ]
        ]
    ]
        |> namespace mainViewNamespace
        |> stylesheet


mainViewNamespace : String
mainViewNamespace =
    Html.Custom.makeNamespace "MainView"



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
                , -Util.pbh
                , -(floor toolbarWidth)
                ]
                    |> List.sum
        in
        div
            [ class [ Main ] ]
            [ Html.map ToolbarMsg (Toolbar.view model.tool)
            , Html.map TaskbarMsg (Taskbar.view model)
            , palette model
            , canvasArea canvasAreaHeight model
            , clickScreen canvasAreaHeight model
            , colorPicker model
            , minimap model
            , Html.Lazy.lazy menu model.menu
            ]



-- GALLERY --


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



-- PALLETE --


palette : Model -> Html Msg
palette model =
    div
        [ class [ Palette ]
        , style [ Util.height Util.pbh ]
        ]
        [ edge
        , Html.Lazy.lazy
            Palette.swatchesView
            model.color.swatches
        , model.color
            |> Html.Lazy.lazy Palette.paletteView
            |> Html.map PaletteMsg
        , infoBox model
        ]


edge : Html Msg
edge =
    div [ class [ Edge ] ] []



-- INFO BOX --


infoBox : Model -> Html msg
infoBox model =
    div
        [ class [ Info ]
        , style
            [ Util.height (Util.pbh - 10) ]
        ]
        (infoBoxContent model)


infoView : String -> Html msg
infoView str =
    p [] [ Html.text str ]


infoBoxContent : Model -> List (Html msg)
infoBoxContent model =
    [ List.map infoView (toolContent model)
    , List.map infoView (generalContent model)
    , sampleColor model
    ]
        |> List.concat


generalContent : Model -> List String
generalContent model =
    [ zoom model.zoom ]
        |> Util.maybeCons (mouse model.mousePosition)


sampleColor : Model -> List (Html msg)
sampleColor model =
    case model.mousePosition of
        Just position ->
            let
                color =
                    Draw.colorAt
                        position
                        model.canvas

                colorStr =
                    Util.toHexColor color

                backgroundColor =
                    if (Color.toHsl color).lightness > 0.5 then
                        ""
                    else
                        "#ffffff"
            in
            [ p
                []
                [ Html.text "color("
                , span
                    [ style
                        [ "color" := colorStr
                        , "background" := backgroundColor
                        ]
                    ]
                    [ Html.text colorStr ]
                , Html.text ")"
                ]
            ]

        Nothing ->
            []


toolContent : Model -> List String
toolContent ({ tool } as model) =
    case tool of
        Data.Tool.Select maybePosition ->
            case ( maybePosition, model.mousePosition ) of
                ( Just origin, Just position ) ->
                    let
                        size =
                            [ "rect("
                            , (origin.x - position.x + 1)
                                |> abs
                                |> toString
                            , ","
                            , (origin.y - position.y + 1)
                                |> abs
                                |> toString
                            , ")"
                            ]

                        originStr =
                            [ "origin("
                            , toString origin.x
                            , ","
                            , toString origin.y
                            , ")"
                            ]
                    in
                    [ size
                    , originStr
                    ]
                        |> List.map String.concat

                _ ->
                    []

        Data.Tool.Rectangle maybePosition ->
            case ( maybePosition, model.mousePosition ) of
                ( Just origin, Just position ) ->
                    let
                        size =
                            [ "rect("
                            , (origin.x - position.x + 1)
                                |> abs
                                |> toString
                            , ","
                            , (origin.y - position.y + 1)
                                |> abs
                                |> toString
                            , ")"
                            ]

                        originStr =
                            [ "origin("
                            , toString origin.x
                            , ","
                            , toString origin.y
                            , ")"
                            ]
                    in
                    [ size
                    , originStr
                    ]
                        |> List.map String.concat

                _ ->
                    []

        Data.Tool.RectangleFilled maybePosition ->
            case ( maybePosition, model.mousePosition ) of
                ( Just origin, Just position ) ->
                    let
                        size =
                            [ "rect("
                            , (origin.x - position.x + 1)
                                |> abs
                                |> toString
                            , ","
                            , (origin.y - position.y + 1)
                                |> abs
                                |> toString
                            , ")"
                            ]

                        originStr =
                            [ "origin("
                            , toString origin.x
                            , ","
                            , toString origin.y
                            , ")"
                            ]
                    in
                    [ size
                    , originStr
                    ]
                        |> List.map String.concat

                _ ->
                    []

        _ ->
            []


mouse : Maybe Mouse.Position -> Maybe String
mouse maybePosition =
    case maybePosition of
        Just { x, y } ->
            [ "mouse(" ++ toString x
            , "," ++ toString y
            , ")"
            ]
                |> String.concat
                |> Just

        Nothing ->
            Nothing


zoom : Int -> String
zoom z =
    "zoom(" ++ toString (z * 100) ++ "%)"



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
colorPicker model =
    if model.color.picker.window.show then
        model.color.picker
            |> Html.Lazy.lazy ColorPicker.view
            |> Html.map ColorPickerMsg
    else
        Html.text ""



-- CLICK SCREEN --


clickScreen : Int -> Model -> Html Msg
clickScreen canvasAreaHeight model =
    div
        [ class [ Screen, toolClass model.tool ]
        , style [ Util.height canvasAreaHeight ]
        , onMouseLeave ScreenMouseExit
        , onMouseMove ScreenMouseMove
        , onMouseDown ScreenMouseDown
        , onMouseUp ScreenMouseUp
        ]
        []


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
            (mainCanvas model)
        , selection model
        ]


mainCanvas : Model -> Canvas
mainCanvas model =
    case model.mousePosition of
        Just position ->
            [ model.drawAtRender
            , toolAtRender model position
            ]
                |> Canvas.batch
                |> flip Canvas.draw model.canvas

        Nothing ->
            Canvas.draw model.drawAtRender model.canvas


toolAtRender : Model -> Mouse.Position -> DrawOp
toolAtRender model position =
    case model.tool of
        Data.Tool.Pencil _ ->
            drawTargetPixel position model.color.swatches.primary

        Data.Tool.Line _ ->
            drawTargetPixel position model.color.swatches.primary

        Data.Tool.Rectangle _ ->
            drawTargetPixel position model.color.swatches.primary

        Data.Tool.RectangleFilled _ ->
            drawTargetPixel position model.color.swatches.primary

        Data.Tool.Sample ->
            drawTargetPixel position model.color.swatches.primary

        Data.Tool.Fill ->
            drawTargetPixel position model.color.swatches.primary

        _ ->
            Canvas.batch []


drawTargetPixel : Mouse.Position -> Color.Color -> DrawOp
drawTargetPixel position color =
    position
        |> Util.toPoint
        |> Draw.pixel color


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
