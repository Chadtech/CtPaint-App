module Minimap.View exposing (view)

import Html exposing (Html, div, p, a, text)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Minimap.Types exposing (Model, Message(..))
import Util exposing (top, left, height, width)
import Canvas exposing (Canvas)
import MouseEvents as Events
import Tool.Types as Tool exposing (Tool(..))


view : Model -> Canvas -> Html Message
view model canvas =
    div
        [ class "card mini-map"
        , style
            [ top model.externalPosition.y
            , left model.externalPosition.x
            , height (model.size.height + 25 + 12 + 25 + 2)
            , width (model.size.width + 8)
            ]
        ]
        [ header model
        , div
            [ class "canvas-container"
            , style
                [ height (model.size.height)
                , width model.size.width
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


header : Model -> Html Message
header model =
    div
        [ class "header"
        , style [ width model.size.width ]
        , Events.onMouseDown HeaderMouseDown
        ]
        [ p [] [ text "mini map" ]
        , a [ onClick CloseClick ] [ text "x" ]
        ]
