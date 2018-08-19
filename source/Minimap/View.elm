module Minimap.View exposing (css, view)

import Canvas exposing (Canvas, DrawOp(DrawImage))
import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Html exposing (Attribute, Html, div)
import Html.Attributes exposing (style)
import Html.CssHelpers
import Html.Custom
    exposing
        ( card
        , cardBody
        , header
        , indent
        )
import Html.Events exposing (onClick)
import Minimap.Constants exposing (portalSize)
import Minimap.Model
    exposing
        ( Model
        , OpenModel
        , OpenState(..)
        )
import Minimap.Msg exposing (Msg(..))
import MouseEvents
import Data.Position as Position
import Selection.Model as Selection
import Tool.Data as Tool
import Util


-- STYLES --


type Class
    = Minimap
    | CanvasContainer
    | Screen
    | Button


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
        , height (px <| toFloat portalSize.height)
        , width (px <| toFloat portalSize.width)
        ]
    , (Css.class CanvasContainer << List.append indent)
        [ position relative
        , backgroundColor Ct.background2
        , overflow hidden
        , cursor move
        , height (px <| toFloat portalSize.height)
        , width (px <| toFloat portalSize.width)
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


view : Model -> Canvas -> Maybe Selection.Model -> Html Msg
view model canvas maybeSelection =
    case model.openState of
        Open openModel ->
            openView model openModel canvas maybeSelection

        Closed _ ->
            Html.text ""


openView : Model -> OpenModel -> Canvas -> Maybe Selection.Model -> Html Msg
openView model openModel canvas maybeSelection =
    card
        [ class [ Minimap ]
        , style
            [ Util.top openModel.position.y
            , Util.left openModel.position.x
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
                , clickScreen
                ]
            , Html.Custom.toolButton
                { icon = Tool.zoomInIcon
                , selected = False
                , attrs =
                    [ class [ Button ]
                    , onClick ZoomInClicked
                    ]
                }
            , Html.Custom.toolButton
                { icon = Tool.zoomOutIcon
                , selected = False
                , attrs =
                    [ class [ Button ]
                    , onClick ZoomOutClicked
                    ]
                }
            , Html.Custom.toolButton
                { icon = Tool.handIcon
                , selected = False
                , attrs =
                    [ class [ Button ]
                    , onClick CenterClicked
                    ]
                }
            ]
        ]


withSelection : Canvas -> Maybe Selection.Model -> Canvas
withSelection canvas maybeSelection =
    case maybeSelection of
        Nothing ->
            canvas

        Just selection ->
            Canvas.draw (drawSelectionOp selection) canvas


drawSelectionOp : Selection.Model -> DrawOp
drawSelectionOp { position, canvas } =
    DrawImage canvas (Canvas.At (Position.toPoint position))


canvasAttrs : Model -> Canvas -> List (Attribute Msg)
canvasAttrs { zoom, canvasPosition } canvas =
    let
        size =
            Canvas.getSize canvas
    in
    [ Util.left canvasPosition.x
    , Util.top canvasPosition.y
    , Util.height (zoom * size.height)
    , Util.width (zoom * size.width)
    ]
        |> style
        |> List.singleton


clickScreen : Html Msg
clickScreen =
    div
        [ class [ Screen ]
        , MouseEvents.onMouseDown MinimapPortalMouseDown
        ]
        []
