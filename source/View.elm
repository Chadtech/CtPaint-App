module View exposing (view)

import Canvas exposing (Canvas)
import ColorPicker.View as ColorPicker
import Html exposing (Attribute, Html, div, p, text)
import Html.Attributes as Attributes exposing (class, id, style)
import Html.Events exposing (onMouseLeave)
import Menu.Download.View as Download
import Menu.Import.View as Import
import Menu.MsgMap
import Menu.Scale.View as Scale
import Menu.Text.View as Text
import Menu.Types exposing (Menu(..))
import Minimap.View as Minimap
import Mouse exposing (Position)
import MouseEvents exposing (onMouseMove)
import Palette.View as Palette
import Taskbar.View as Taskbar
import Tool exposing (Tool(..))
import Tool.Fill.Mouse as Fill
import Tool.Hand.Mouse as Hand
import Tool.Line.Mouse as Line
import Tool.Pencil.Mouse as Pencil
import Tool.Rectangle.Mouse as Rectangle
import Tool.RectangleFilled.Mouse as RectangleFilled
import Tool.Sample.Mouse as Sample
import Tool.Select.Mouse as Select
import Tool.ZoomIn.Mouse as ZoomIn
import Tool.ZoomOut.Mouse as ZoomOut
import Toolbar.View as Toolbar
import Types exposing (Model, Msg(..))
import Util exposing ((:=), height, left, top, width)


-- VIEW --


view : Model -> Html Msg
view model =
    if model.galleryView then
        galleryView model
    else
        let
            canvasAreaHeight =
                List.sum
                    [ model.windowSize.height
                    , -model.horizontalToolbarHeight
                    , -29
                    ]
        in
        div
            [ class "main" ]
            [ Toolbar.view model
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
        [ class "main gallery" ]
        [ Canvas.toHtml [] model.canvas ]



-- MENU --


menu : Menu -> Html Msg
menu m =
    case m of
        None ->
            Html.text ""

        Download model ->
            Html.map
                Menu.MsgMap.download
                (Download.view model)

        Import model ->
            Html.map
                Menu.MsgMap.import_
                (Import.view model)

        Scale model ->
            Html.map
                Menu.MsgMap.scale
                (Scale.view model)

        Text model ->
            Html.map
                Menu.MsgMap.text
                (Text.view model)



-- MINI MAP --


minimap : Model -> Html Msg
minimap model =
    case model.minimap of
        Just minimapModel ->
            Html.map
                MinimapMsg
                (Minimap.view minimapModel model.canvas)

        Nothing ->
            Html.text ""



-- COLOR PICKER --


colorPicker : Model -> Html Msg
colorPicker { colorPicker } =
    if colorPicker.show then
        Html.map
            ColorPickerMsg
            (ColorPicker.view colorPicker)
    else
        Html.text ""



-- CLICK SCREEN --


clickScreen : Int -> Model -> Html Msg
clickScreen canvasAreaHeight { tool } =
    let
        attributes =
            addToolAttributes
                tool
                [ class ("screen " ++ Tool.name tool)
                , style
                    [ height canvasAreaHeight ]
                , onMouseLeave ScreenMouseExit
                , onMouseMove ScreenMouseMove
                ]
    in
    div attributes []


addToolAttributes : Tool -> List (Attribute Msg) -> List (Attribute Msg)
addToolAttributes tool attributes =
    let
        toolAttributes =
            case tool of
                Hand _ ->
                    List.map
                        (Attributes.map Tool.HandMsg)
                        Hand.attributes

                Sample ->
                    List.map
                        (Attributes.map Tool.SampleMsg)
                        Sample.attributes

                Fill ->
                    List.map
                        (Attributes.map Tool.FillMsg)
                        Fill.attributes

                Pencil _ ->
                    List.map
                        (Attributes.map Tool.PencilMsg)
                        Pencil.attributes

                Line _ ->
                    List.map
                        (Attributes.map Tool.LineMsg)
                        Line.attributes

                Rectangle _ ->
                    List.map
                        (Attributes.map Tool.RectangleMsg)
                        Rectangle.attributes

                RectangleFilled _ ->
                    List.map
                        (Attributes.map Tool.RectangleFilledMsg)
                        RectangleFilled.attributes

                Select _ ->
                    List.map
                        (Attributes.map Tool.SelectMsg)
                        Select.attributes

                ZoomIn ->
                    List.map
                        (Attributes.map Tool.ZoomInMsg)
                        ZoomIn.attributes

                ZoomOut ->
                    List.map
                        (Attributes.map Tool.ZoomOutMsg)
                        ZoomOut.attributes
    in
    List.concat
        [ List.map
            (Attributes.map ToolMsg)
            toolAttributes
        , attributes
        ]



-- CANVAS --


canvasArea : Int -> Model -> Html Msg
canvasArea canvasAreaHeight model =
    div
        [ class "canvas-area"
        , style
            [ height canvasAreaHeight ]
        ]
        [ Canvas.toHtml
            [ class "main-canvas"
            , id "main-canvas"
            , style (canvasStyles model)
            ]
            (Canvas.draw model.drawAtRender model.canvas)
        , selection model
        ]


canvasStyles : Model -> List ( String, String )
canvasStyles ({ zoom, canvasPosition, canvas } as model) =
    let
        canvasSize =
            Canvas.getSize canvas
    in
    [ left canvasPosition.x
    , top canvasPosition.y
    , width (canvasSize.width * zoom)
    , height (canvasSize.height * zoom)
    ]


selection : Model -> Html Msg
selection model =
    case model.selection of
        Just ( position, canvas ) ->
            div
                [ style (selectionStyles model position canvas) ]
                [ Canvas.toHtml
                    [ class "selection-canvas"
                    , style (selectionStyles model position canvas)
                    ]
                    canvas
                ]

        Nothing ->
            Html.text ""


selectionStyles : Model -> Position -> Canvas -> List ( String, String )
selectionStyles ({ zoom, canvasPosition, canvas } as model) position selection =
    let
        selectionSize =
            Canvas.getSize selection
    in
    [ left (canvasPosition.x + position.x * zoom + 1)
    , top (canvasPosition.y + position.y * zoom + 1)
    , width (selectionSize.width * zoom)
    , height (selectionSize.height * zoom)
    ]
