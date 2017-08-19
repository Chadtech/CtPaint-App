module Main.View exposing (view)

import Html exposing (Html, Attribute, div, p, text)
import Html.Attributes as Attributes exposing (class, style)
import Html.Events exposing (onMouseLeave)
import MouseEvents exposing (onMouseMove)
import Main.Model exposing (Model)
import Main.Message exposing (Message(..))
import Toolbar.Vertical.View as ToolbarVertical
import Toolbar.Horizontal.View as ToolbarHorizontal
import Toolbar.Top.View as ToolbarTop
import ColorPicker.View as ColorPicker
import Util exposing ((:=), left, top, width, height)
import Canvas exposing (Canvas)
import Mouse exposing (Position)
import Tool.Types as Tool exposing (Tool(..))
import Tool.Hand.Mouse as Hand
import Tool.Pencil.Mouse as Pencil
import Tool.ZoomIn.Mouse as ZoomIn
import Tool.ZoomOut.Mouse as ZoomOut
import Tool.Rectangle.Mouse as Rectangle
import Tool.RectangleFilled.Mouse as RectangleFilled
import Tool.Select.Mouse as Select
import Tool.Sample.Mouse as Sample
import Tool.Fill.Mouse as Fill


-- VIEW --


view : Model -> Html Message
view model =
    let
        { width, height } =
            model.windowSize

        canvasAreaHeight =
            height - model.horizontalToolbarHeight - 29
    in
        div
            [ class "main" ]
            [ ToolbarVertical.view model
            , ToolbarTop.view
            , horizontalToolbar model
            , canvasArea canvasAreaHeight model
            , clickScreen canvasAreaHeight model
            , colorPicker model
            ]



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
                [ class ("screen " ++ (Tool.name tool))
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



-- TOOL BARS --


horizontalToolbar : Model -> Html Message
horizontalToolbar model =
    Html.map
        HorizontalToolbarMessage
        (ToolbarHorizontal.view model)
