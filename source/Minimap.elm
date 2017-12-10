module Minimap
    exposing
        ( css
        , init
        , subscriptions
        , update
        , view
        )

import Canvas
    exposing
        ( Canvas
        , DrawImageParams(..)
        , DrawOp(..)
        )
import Chadtech.Colors exposing (backgroundx2)
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Data.Minimap
    exposing
        ( ClickState(..)
        , Model
        , Msg(..)
        , Reply(..)
        )
import Data.Tool exposing (Tool(..))
import Helpers.Zoom as Zoom
import Html exposing (Attribute, Html, a, div, p)
import Html.Attributes exposing (style)
import Html.CssHelpers
import Html.Custom exposing (card, cardBody, header, indent)
import Html.Events exposing (onClick)
import Mouse
import MouseEvents exposing (MouseEvent)
import Tool
import Tuple.Infix exposing ((&))
import Util exposing (toPoint)
import Window exposing (Size)


-- INIT --


init : Maybe Mouse.Position -> Size -> Model
init maybeInitialPosition { width, height } =
    { externalPosition =
        case maybeInitialPosition of
            Just position ->
                position

            Nothing ->
                { x = (width - floor minimapWidth) // 2
                , y = (height - floor minimapHeight) // 2
                }
    , internalPosition =
        { x = 0
        , y = 0
        }
    , zoom = 1
    , clickState = NoClicks
    }


extraHeight : Int
extraHeight =
    64


extraWidth : Int
extraWidth =
    8



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.clickState of
        NoClicks ->
            Sub.none

        _ ->
            [ Mouse.moves MouseMoved
            , Mouse.ups (always MouseUp)
            ]
                |> Sub.batch



-- UPDATE --


update : Msg -> Model -> Canvas -> ( Model, Reply )
update message model canvas =
    case message of
        XButtonMouseUp ->
            model & Close

        XButtonMouseDown ->
            { model
                | clickState = XButtonIsDown
            }
                & NoReply

        ZoomInClicked ->
            zoomIn canvas model & NoReply

        ZoomOutClicked ->
            zoomOut canvas model & NoReply

        ScreenMouseDown { targetPos, clientPos } ->
            { model
                | clickState =
                    let
                        { x, y } =
                            model.internalPosition
                    in
                    { x = clientPos.x - x
                    , y = clientPos.y - y
                    }
                        |> ClickedInScreenAt
            }
                & NoReply

        HeaderMouseDown { targetPos, clientPos } ->
            case model.clickState of
                XButtonIsDown ->
                    model & NoReply

                _ ->
                    { model
                        | clickState =
                            { x = clientPos.x - targetPos.x
                            , y = clientPos.y - targetPos.y
                            }
                                |> ClickedInHeaderAt
                    }
                        & NoReply

        MouseMoved position ->
            case model.clickState of
                NoClicks ->
                    model & NoReply

                XButtonIsDown ->
                    model & NoReply

                ClickedInHeaderAt originalClick ->
                    { model
                        | externalPosition =
                            { x = position.x - originalClick.x
                            , y = position.y - originalClick.y
                            }
                    }
                        & NoReply

                ClickedInScreenAt originalClick ->
                    { model
                        | internalPosition =
                            { x = position.x - originalClick.x
                            , y = position.y - originalClick.y
                            }
                    }
                        & NoReply

        MouseUp ->
            { model
                | clickState = NoClicks
            }
                & NoReply


zoomOut : Canvas -> Model -> Model
zoomOut canvas model =
    { model
        | zoom = Zoom.prev model.zoom
    }


zoomIn : Canvas -> Model -> Model
zoomIn canvas model =
    let
        nextZoom =
            Zoom.next model.zoom

        { width, height } =
            Canvas.getSize canvas

        dw =
            width * (nextZoom - model.zoom)

        dh =
            height * (nextZoom - model.zoom)
    in
    { model
        | zoom = nextZoom
    }



-- STYLES --


type Class
    = Minimap
    | CanvasContainer
    | Screen
    | Button


minimapWidth : Float
minimapWidth =
    250


minimapHeight : Float
minimapHeight =
    250


css : Stylesheet
css =
    [ Css.class Minimap
        [ position absolute
        , paddingBottom (px 2)
        ]
    , Css.class Screen
        [ position absolute
        , left (px 0)
        , top (px 0)
        , height (px minimapHeight)
        , width (px minimapWidth)
        ]
    , (Css.class CanvasContainer << List.append indent)
        [ position relative
        , backgroundColor backgroundx2
        , overflow hidden
        , cursor move
        , width (px minimapWidth)
        , height (px minimapHeight)
        , children
            [ Css.Elements.canvas
                [ position absolute ]
            ]
        ]
    , Css.class Button
        [ marginRight (px 1)
        , marginTop (px 2)
        ]
    ]
        |> namespace minimapNamespace
        |> stylesheet


minimapNamespace : String
minimapNamespace =
    Html.Custom.makeNamespace "Minimap"



-- VIEW --


{ class, classList } =
    Html.CssHelpers.withNamespace minimapNamespace


view : Model -> Canvas -> Maybe ( Mouse.Position, Canvas ) -> Html Msg
view model canvas maybeSelection =
    card
        [ class [ Minimap ]
        , style
            [ Util.top model.externalPosition.y
            , Util.left model.externalPosition.x
            ]
        ]
        [ header
            { text = "mini map"
            , headerMouseDown = HeaderMouseDown
            , xButtonMouseDown = XButtonMouseDown
            , xButtonMouseUp = XButtonMouseUp
            }
        , cardBody
            []
            [ div
                [ class [ CanvasContainer ] ]
                [ Canvas.toHtml
                    (canvasAttrs model canvas)
                    (withSelection canvas maybeSelection)
                , screen
                ]
            , Html.Custom.toolButton
                { icon = Tool.icon ZoomIn
                , selected = False
                , attrs =
                    [ class [ Button ]
                    , onClick ZoomInClicked
                    ]
                }
            , Html.Custom.toolButton
                { icon = Tool.icon ZoomOut
                , selected = False
                , attrs =
                    [ class [ Button ]
                    , onClick ZoomOutClicked
                    ]
                }
            ]
        ]


withSelection : Canvas -> Maybe ( Mouse.Position, Canvas ) -> Canvas
withSelection canvas maybeSelection =
    case maybeSelection of
        Nothing ->
            canvas

        Just ( position, selection ) ->
            let
                drawOp =
                    DrawImage
                        selection
                        (At (toPoint position))
            in
            Canvas.draw drawOp canvas


canvasAttrs : Model -> Canvas -> List (Attribute Msg)
canvasAttrs { zoom, internalPosition } canvas =
    let
        size =
            Canvas.getSize canvas
    in
    [ Util.left internalPosition.x
    , Util.top internalPosition.y
    , Util.height (zoom * size.height)
    , Util.width (zoom * size.width)
    ]
        |> style
        |> List.singleton


screen : Html Msg
screen =
    div
        [ class [ Screen ]
        , MouseEvents.onMouseDown ScreenMouseDown
        ]
        []
