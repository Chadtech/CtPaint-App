module Toolbar.Horizontal.View exposing (..)

import Html exposing (Html, div, a, text)
import Html.Attributes exposing (class, style)
import ElementRelativeMouseEvents as Events
import Toolbar.Horizontal.Types exposing (Message(..))
import Util exposing ((:=), px)
import Types.Mouse exposing (Direction(..))


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
        , Util.toPosition
            >> Down
            >> ResizeToolbar
            |> Events.onMouseDown
        , Util.toPosition
            >> Up
            >> ResizeToolbar
            |> Events.onMouseUp
        ]
        []
