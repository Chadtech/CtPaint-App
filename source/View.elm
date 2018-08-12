module View exposing (css, view)

import Canvas exposing (Canvas, DrawOp)
import Canvas.Draw as Draw
import Chadtech.Colors as Ct
import Color
import Color.Msg
import Color.Palette.View as Palette
import Color.Picker.View as Picker
import Color.Swatches.View as Swatches
import Color.Util
import Css exposing (..)
import Css.Elements exposing (canvas)
import Css.Namespace exposing (namespace)
import Data.Keys as Key
import Data.Minimap exposing (State(..))
import Helpers.Keys
import Html
    exposing
        ( Attribute
        , Html
        , div
        , input
        , p
        , span
        )
import Html.Attributes as Attr
import Html.CssHelpers
import Html.Custom exposing (indent)
import Html.Events exposing (onClick, onMouseLeave)
import Html.Lazy
import Menu.View as Menu
import Minimap
import Model exposing (Model)
import Mouse.Extra
import MouseEvents
    exposing
        ( MouseEvent
        , onMouseMove
        , onMouseUp
        )
import Msg exposing (Msg(..))
import Position.Data as Position
import Style
import Taskbar
import Tool.Data exposing (Tool)
import Tool.Msg
import Toolbar
import Util exposing (def)


-- STYLES --


type Class
    = Main
    | Gallery
    | GalleryScreen
    | GalleryNotice
    | CanvasArea
    | MainCanvas
    | SelectionCanvas
    | SelectionCanvasContainer
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
    | Eraser
    | Info
    | Edge
    | Palette


css : Stylesheet
css =
    [ Css.class Main
        [ width (pct 100)
        , height (pct 100)
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
    , Css.class GalleryScreen
        [ width (pct 100)
        , height (pct 100)
        , position absolute
        , left (px 0)
        , top (px 0)
        ]
    , (Css.class GalleryNotice << List.concat)
        [ [ left (px 8)
          , top (px 8)
          , position absolute
          , textDecoration none
          , backgroundColor Ct.ignorable2
          , display inlineBlock
          , padding4 (px 4) (px 8) (px 4) (px 8)
          ]
        , Html.Custom.outdent
        , Html.Custom.cannotSelect
        ]
    , Css.class MainCanvas
        [ position absolute
        , border3 (px 2) solid Ct.ignorable2
        ]
    , Css.class SelectionCanvas
        [ position absolute
        , left (px 0)
        , top (px 0)
        ]
    , Css.class SelectionCanvasContainer
        [ position absolute
        , border2 (px 1) solid
        , property "border-image" "url(\"./selection.gif\") 1 1 repeat"
        ]
    , Css.class CanvasArea
        [ position absolute
        , overflow hidden
        , width (calc (pct 100) minus (px <| toFloat Style.toolbarWidth))
        , left (px <| toFloat Style.toolbarWidth)
        , top (px <| toFloat Style.taskbarHeight)
        ]
    , Css.class Screen
        [ position absolute
        , width (calc (pct 100) minus (px <| toFloat Style.toolbarWidth))
        , left (px <| toFloat Style.toolbarWidth)
        , top (px <| toFloat Style.taskbarHeight)
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
        [ backgroundColor Ct.ignorable2
        , position fixed
        , bottom (px 0)
        , left (px <| toFloat Style.toolbarWidth)
        , width (calc (pct 100) minus (px 29))
        ]
    , Css.class Edge
        [ height (px 3)
        , borderTop3 (px 2) solid Ct.ignorable1
        , top (px 0)
        , left (px 0)
        , cursor nsResize
        ]
    , (Css.class Info << List.append indent)
        [ backgroundColor Ct.background2
        , width (px 390)
        , position absolute
        , left (calc (pct 100) minus (px 397))
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
                , -Style.palettebarHeight
                , -Style.toolbarWidth
                ]
                    |> List.sum
        in
        div
            [ class [ Main ] ]
            [ Html.map ToolbarMsg (Toolbar.view model)
            , Html.map TaskbarMsg (Taskbar.view model)
            , palette model
            , canvasArea canvasAreaHeight model
            , workareaClickScreen canvasAreaHeight model
            , model.color
                |> Html.Lazy.lazy Picker.view
                |> Html.map (ColorMsg << Color.Msg.PickerMsg)
            , minimap model
            , Html.Lazy.lazy Menu.view model.menu
                |> Html.map MenuMsg
            ]



-- GALLERY --


galleryView : Model -> Html Msg
galleryView model =
    div
        [ class [ Main, Gallery ] ]
        [ Canvas.toHtml [] model.canvas.main
        , div
            [ class [ GalleryScreen ]
            , onClick GalleryScreenClicked
            ]
            [ galleryNotice model ]
        ]


galleryNotice : Model -> Html Msg
galleryNotice model =
    [ "Click anywhere or press"
    , Helpers.Keys.getKeysLabel
        model.taco.config
        Key.SwitchGalleryView
    , "to exit"
    ]
        |> String.join " "
        |> Html.text
        |> List.singleton
        |> p [ class [ GalleryNotice ] ]



-- PALLETE --


palette : Model -> Html Msg
palette model =
    div
        [ class [ Palette ]
        , Attr.style [ Util.height Style.palettebarHeight ]
        ]
        [ div [ class [ Edge ] ] []
        , Html.Lazy.lazy
            Swatches.view
            model.color.swatches
        , model.color
            |> Html.Lazy.lazy Palette.view
            |> Html.map (ColorMsg << Color.Msg.PaletteMsg)
        , infoBox model
        ]



-- INFO BOX --


infoBox : Model -> Html msg
infoBox model =
    div
        [ class [ Info ]
        , Attr.style
            [ Util.height (Style.palettebarHeight - 10) ]
        ]
        (infoBoxContent model)


infoView : String -> Html msg
infoView str =
    p [] [ Html.text str ]


infoBoxContent : Model -> List (Html msg)
infoBoxContent model =
    [ List.map infoView (toolContent model)
    , sampleColor model
    , List.map infoView (generalContent model)
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
                color : Color.Color
                color =
                    Draw.colorAt
                        position
                        model.canvas.main

                colorStr : String
                colorStr =
                    Color.Util.toHexString color
            in
            [ p
                []
                [ Html.text "color("
                , span
                    [ Attr.style
                        [ def "color" colorStr
                        , color
                            |> sampleColorBackgroundStr
                            |> def "background"
                        ]
                    ]
                    [ Html.text colorStr ]
                , Html.text ")"
                ]
            ]

        Nothing ->
            []


sampleColorBackgroundStr : Color.Color -> String
sampleColorBackgroundStr color =
    if (Color.toHsl color).lightness > 0.5 then
        ""
    else
        "#ffffff"


rectInfo : Position.Position -> Position.Position -> List String
rectInfo origin position =
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


originInfo : Position.Position -> List String
originInfo p =
    [ "origin("
    , toString p.x
    , ","
    , toString p.y
    , ")"
    ]


toolContent : Model -> List String
toolContent ({ tool } as model) =
    case tool of
        Tool.Data.Select maybePosition ->
            case ( maybePosition, model.mousePosition ) of
                ( Just origin, Just position ) ->
                    [ rectInfo origin position
                    , originInfo origin
                    ]
                        |> List.map String.concat

                _ ->
                    []

        Tool.Data.Rectangle subModel ->
            case ( subModel, model.mousePosition ) of
                ( Just { initialClickPositionOnCanvas }, Just position ) ->
                    [ rectInfo initialClickPositionOnCanvas position
                    , originInfo initialClickPositionOnCanvas
                    ]
                        |> List.map String.concat

                _ ->
                    []

        Tool.Data.RectangleFilled subModel ->
            case ( subModel, model.mousePosition ) of
                ( Just { initialClickPositionOnCanvas }, Just position ) ->
                    [ rectInfo initialClickPositionOnCanvas position
                    , originInfo initialClickPositionOnCanvas
                    ]
                        |> List.map String.concat

                _ ->
                    []

        _ ->
            []


mouse : Maybe Position.Position -> Maybe String
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
                model.canvas.main
                model.selection
                |> Html.map MinimapMsg

        _ ->
            Html.text ""


{-| This is a transparent div that sits over
the work area. Its purpose is to be clickable
so that mouse events can be recorded relative to
the work area, instead of the client window as
a whole.
-}
workareaClickScreen : Int -> Model -> Html Msg
workareaClickScreen canvasAreaHeight model =
    div
        [ class [ Screen, toolClass model.tool ]
        , Attr.style [ Util.height canvasAreaHeight ]
        , onMouseLeave WorkareaMouseExit
        , onMouseMove WorkareaMouseMove
        , Mouse.Extra.onMouseDown
            model.taco.config.isMac
            (workareaMouseDownMsg model)
        , onMouseUp (workareaMouseUpMsg model)

        -- Necessary in order to capture the context
        -- menu event, and prevent it, even though
        -- we dont do anything from this Msg
        ----v
        , Mouse.Extra.onContextMenu WorkareaContextMenu
        ]
        []


workareaMouseUpMsg : Model -> MouseEvent -> Msg
workareaMouseUpMsg model { clientPos } =
    Tool.Msg.WorkareaMouseUp clientPos
        -- (Position.Helpers.onCanvas model clientPos)
        |> ToolMsg


workareaMouseDownMsg : Model -> Mouse.Extra.Button -> MouseEvent -> Msg
workareaMouseDownMsg model button { clientPos } =
    Tool.Msg.WorkareaMouseDown
        button
        clientPos
        -- (Position.Helpers.onCanvas model clientPos)
        |> ToolMsg


toolClass : Tool -> Class
toolClass tool =
    case tool of
        Tool.Data.Hand _ ->
            Hand

        Tool.Data.Sample ->
            Sample

        Tool.Data.Fill ->
            Fill

        Tool.Data.Pencil _ ->
            Pencil

        Tool.Data.Line _ ->
            Line

        Tool.Data.Rectangle _ ->
            Rectangle

        Tool.Data.RectangleFilled _ ->
            RectangleFilled

        Tool.Data.Select _ ->
            Select

        Tool.Data.ZoomIn ->
            ZoomIn

        Tool.Data.ZoomOut ->
            ZoomOut

        Tool.Data.Eraser _ ->
            Eraser



-- CANVAS --


canvasArea : Int -> Model -> Html Msg
canvasArea canvasAreaHeight model =
    div
        [ class [ CanvasArea ]
        , Attr.style [ Util.height canvasAreaHeight ]
        ]
        [ Canvas.toHtml
            [ class [ MainCanvas ]
            , Attr.id "main-canvas"
            , canvasStyles model
            ]
            (mainCanvas model)
        , selection model
        ]


mainCanvas : Model -> Canvas
mainCanvas model =
    case model.mousePosition of
        Just position ->
            [ model.draws.atRender
            , toolAtRender model position
            ]
                |> Canvas.batch
                |> flip Canvas.draw model.canvas.main

        Nothing ->
            Canvas.draw
                model.draws.atRender
                model.canvas.main


toolAtRender : Model -> Position.Position -> DrawOp
toolAtRender model position =
    case model.tool of
        Tool.Data.Pencil _ ->
            drawTargetPixel position model.color.swatches.top

        Tool.Data.Line _ ->
            drawTargetPixel position model.color.swatches.top

        Tool.Data.Rectangle _ ->
            drawTargetPixel position model.color.swatches.top

        Tool.Data.RectangleFilled _ ->
            drawTargetPixel position model.color.swatches.top

        Tool.Data.Sample ->
            drawTargetPixel position model.color.swatches.top

        Tool.Data.Fill ->
            drawTargetPixel position model.color.swatches.top

        Tool.Data.Eraser _ ->
            drawTargetEraser position model

        _ ->
            Canvas.batch []


drawTargetEraser : Position.Position -> Model -> DrawOp
drawTargetEraser position { color, eraserSize } =
    Draw.eraserPoint color.swatches.top eraserSize position


drawTargetPixel : Position.Position -> Color.Color -> DrawOp
drawTargetPixel position color =
    position
        |> Position.toPoint
        |> Draw.pixel color


canvasStyles : Model -> Attribute Msg
canvasStyles { zoom, canvas } =
    let
        canvasSize =
            Canvas.getSize canvas.main
    in
    [ Util.left canvas.position.x
    , Util.top canvas.position.y
    , Util.width (canvasSize.width * zoom)
    , Util.height (canvasSize.height * zoom)
    ]
        |> Attr.style


selection : Model -> Html Msg
selection model =
    case model.selection of
        Just { position, canvas } ->
            div
                [ class [ SelectionCanvasContainer ]
                , selectionContainerStyle model position canvas
                ]
                [ Canvas.toHtml
                    [ class [ SelectionCanvas ]
                    , selectionStyle model position canvas
                    ]
                    canvas
                ]

        Nothing ->
            Html.text ""


selectionStyle : Model -> Position.Position -> Canvas -> Attribute Msg
selectionStyle { zoom } position selection =
    let
        selectionSize =
            Canvas.getSize selection
    in
    [ Util.width (selectionSize.width * zoom)
    , Util.height (selectionSize.height * zoom)
    ]
        |> Attr.style


selectionContainerStyle : Model -> Position.Position -> Canvas -> Attribute Msg
selectionContainerStyle { zoom, canvas } position selection =
    let
        selectionSize =
            Canvas.getSize selection
    in
    [ Util.left (canvas.position.x + position.x * zoom + 1)
    , Util.top (canvas.position.y + position.y * zoom + 1)
    , Util.width (selectionSize.width * zoom)
    , Util.height (selectionSize.height * zoom)
    ]
        |> Attr.style
