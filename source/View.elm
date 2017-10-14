module View exposing (view)

import Canvas exposing (Canvas)
import ColorPicker
import Html exposing (Attribute, Html, div, p, text)
import Html.Attributes as Attributes exposing (class, id, style)
import Html.Events exposing (onMouseLeave)
import Menu exposing (Menu)
import Minimap
import Mouse exposing (Position)
import MouseEvents exposing (onMouseMove)
import Palette
import Taskbar
import Tool exposing (Tool(..))
import Toolbar
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
            , Taskbar.view model
            , Palette.view model
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


menu : Maybe Menu.Model -> Html Msg
menu maybeMenuModel =
    case maybeMenuModel of
        Just menuModel ->
            Html.map MenuMsg (Menu.view menuModel)

        Nothing ->
            Html.text ""



--menu : Menu -> Html Msg
--menu m =
--    case m of
--        None ->
--            Html.text ""
--        Download model ->
--            Html.map
--                Menu.MsgMap.download
--                (Download.view model)
--        Import model ->
--            Html.map
--                Menu.MsgMap.import_
--                (Import.view model)
--        Scale model ->
--            Html.map
--                Menu.MsgMap.scale
--                (Scale.view model)
--        Text model ->
--            Html.map
--                Menu.MsgMap.text
--                (Text.view model)
--        About ->
--            Html.map MenuMsg About.view
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
            [ class ("screen " ++ Tool.name tool)
            , style [ height canvasAreaHeight ]
            , onMouseLeave ScreenMouseExit
            , onMouseMove ScreenMouseMove
            ]

        toolAttrs =
            List.map
                (Attributes.map ToolMsg)
                (Tool.attributes tool)
    in
    div (toolAttrs ++ attributes) []



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
