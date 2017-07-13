module Toolbar.Horizontal.View exposing (..)

import Html exposing (Html, div, a, text)
import Html.Attributes exposing (class, style)
import Main.Model exposing (Model)
import ElementRelativeMouseEvents as Events
import Toolbar.Horizontal.Types exposing (Message(..))
import Util exposing ((:=), px)
import Types.Mouse exposing (Direction(..))
import Palette.View as Palette


view : Model -> Html Message
view model =
    div
        [ class "horizontal-tool-bar"
        , style
            [ "height" := (px model.horizontalToolbarHeight) ]
        ]
        [ edge
        , Palette.view model
        ]


edge : Html Message
edge =
    div
        [ class "edge"
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
