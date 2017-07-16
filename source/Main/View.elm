module Main.View exposing (view)

import Html exposing (Html, Attribute, div, p, text)
import Html.Attributes as Attributes exposing (class, style)
import Main.Model exposing (Model)
import Main.Message exposing (Message(..))
import Toolbar.Vertical.View as ToolbarVertical
import Toolbar.Horizontal.View as ToolbarHorizontal
import Toolbar.Top.View as ToolbarTop
import Util exposing ((:=), left, top, width, height)
import Canvas
import Tool.Types as Tool exposing (Tool(..))
import Tool.Hand.Mouse as Hand
import Tool.Pencil.Mouse as Pencil
import Tool.ZoomIn.Mouse as ZoomIn
import Tool.ZoomOut.Mouse as ZoomOut


-- VIEW --


view : Model -> Html Message
view model =
    let
        { width, height } =
            model.windowSize

        canvasAreaHeight =
            height - model.horizontalToolbarHeight
    in
        div
            [ class "main" ]
            [ ToolbarVertical.view model
            , ToolbarTop.view
            , horizontalToolbar model
            , canvasArea canvasAreaHeight model
            , clickScreen canvasAreaHeight model
            ]



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

                Pencil _ ->
                    List.map
                        (Attributes.map PencilMessage)
                        Pencil.attributes

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
            model.canvas
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



-- TOOL BARS --


horizontalToolbar : Model -> Html Message
horizontalToolbar model =
    Html.map
        HorizontalToolbarMessage
        (ToolbarHorizontal.view model)
