module Toolbar.Horizontal.View exposing (..)

import Html exposing (Html, div, a, text)
import Html.Attributes exposing (class, style)
import Main.Message exposing (Message)
import Util exposing ((:=), px)


view : Int -> Html Message
view height =
    div
        [ class "horizontal-tool-bar" ]
        [ edge height ]


edge : Int -> Html Message
edge height =
    div
        [ class "edge"
        , style
            [ "height" := (px height) ]
        ]
        []
