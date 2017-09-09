module Main.View exposing (view)

import Canvas exposing (Canvas)
import ColorPicker.View as ColorPicker
import Html exposing (Attribute, Html, div, p, text)
import Html.Attributes as Attributes exposing (class, id, style)
import Html.Events exposing (onMouseLeave)
import Main.Message exposing (Message(..))
import Main.Model exposing (Model)
import Menu.Types exposing (Menu(..))
import Minimap.View as Minimap
import Mouse exposing (Position)
import MouseEvents exposing (onMouseMove)
import Palette.View as Palette
import Taskbar.Download.View as Download
import Taskbar.Import.View as Import
import Taskbar.Util as Taskbar
import Taskbar.View as Taskbar
import Tool.Fill.Mouse as Fill
import Tool.Hand.Mouse as Hand
import Tool.Line.Mouse as Line
import Tool.Pencil.Mouse as Pencil
import Tool.Rectangle.Mouse as Rectangle
import Tool.RectangleFilled.Mouse as RectangleFilled
import Tool.Sample.Mouse as Sample
import Tool.Select.Mouse as Select
import Tool.Types as Tool exposing (Tool(..))
import Tool.ZoomIn.Mouse as ZoomIn
import Tool.ZoomOut.Mouse as ZoomOut
import Toolbar.View as Toolbar
import Util exposing ((:=), height, left, top, width)


-- VIEW --


view : Model -> Html Message
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
            , Html.map TaskbarMessage (Taskbar.view model)
            , Html.map PaletteMessage (Palette.view model)
            , canvasArea canvasAreaHeight model
            , clickScreen canvasAreaHeight model
            , colorPicker model
            , minimap model
            , menu model.menu
            ]


galleryView : Model -> Html Message
galleryView model =
    div
        [ class "main gallery" ]
        [ Canvas.toHtml [] model.canvas ]



-- MENU --


menu : Menu -> Html Message
menu m =
    case m of
        None ->
            Html.text ""

        Download model ->
            Html.map Taskbar.download (Download.view model)

        Import model ->
            Html.map Taskbar.import_ (Import.view model)

        _ ->
            Html.text ""



-- MINI MAP --


minimap : Model -> Html Message
minimap model =
    case model.minimap of
        Just minimapModel ->
            Html.map
                MinimapMessage
                (Minimap.view minimapModel model.canvas)

        Nothing ->
            Html.text ""



-- COLOR PICKER --


colorPicker : Model -> Html Message
colorPicker { colorPicker } =
    if colorPicker.show then
        Html.map
            ColorPickerMessage
            (ColorPicker.view colorPicker)
    else
        Html.text ""



-- CLICK SCREEN --


clickScreen : Int -> Model -> Html Message
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


addToolAttributes : Tool -> List (Attribute Message) -> List (Attribute Message)
addToolAttributes tool attributes =
    let
        toolAttributes =
            case tool of
                Hand _ ->
                    List.map
                        (Attributes.map HandMessage)
                        Hand.attributes

                Sample ->
                    List.map
                        (Attributes.map SampleMessage)
                        Sample.attributes

                Fill ->
                    List.map
                        (Attributes.map FillMessage)
                        Fill.attributes

                Pencil _ ->
                    List.map
                        (Attributes.map PencilMessage)
                        Pencil.attributes

                Line _ ->
                    List.map
                        (Attributes.map LineMessage)
                        Line.attributes

                Rectangle _ ->
                    List.map
                        (Attributes.map RectangleMessage)
                        Rectangle.attributes

                RectangleFilled _ ->
                    List.map
                        (Attributes.map RectangleFilledMessage)
                        RectangleFilled.attributes

                Select _ ->
                    List.map
                        (Attributes.map SelectMessage)
                        Select.attributes

                ZoomIn ->
                    List.map
                        (Attributes.map ZoomInMessage)
                        ZoomIn.attributes

                ZoomOut ->
                    List.map
                        (Attributes.map ZoomOutMessage)
                        ZoomOut.attributes
    in
    toolAttributes ++ attributes



-- CANVAS --


canvasArea : Int -> Model -> Html Message
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


selection : Model -> Html Message
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
