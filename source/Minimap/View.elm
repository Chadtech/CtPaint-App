module Minimap.View exposing (view)

import Canvas exposing (Canvas)
import Html exposing (Html, a, div, p, text)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Minimap.Types
    exposing
        ( Model
        , Msg(..)
        , extraHeight
        , extraWidth
        )
import MouseEvents as Events
import Tool exposing (Tool(..))
import Util exposing (height, left, top, width)


view : Model -> Canvas -> Html Msg
view model canvas =
    div
        [ class "card mini-map"
        , style
            [ top model.externalPosition.y
            , left model.externalPosition.x
            , height model.size.height
            , width model.size.width
            ]
        ]
        [ header model
        , div
            [ class "canvas-container"
            , style
                [ height (model.size.height - extraHeight)
                , width (model.size.width - extraWidth)
                ]
            ]
            [ Canvas.toHtml [] canvas ]
        , a
            [ class "tool-button" ]
            [ text (Tool.icon ZoomIn) ]
        , a
            [ class "tool-button" ]
            [ text (Tool.icon ZoomOut) ]
        ]


header : Model -> Html Msg
header model =
    div
        [ class "header"
        , style [ width (model.size.width - extraWidth) ]
        , Events.onMouseDown HeaderMouseDown
        ]
        [ p [] [ text "mini map" ]
        , a [ onClick CloseClick ] [ text "x" ]
        ]
