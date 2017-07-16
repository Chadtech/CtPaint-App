module Toolbar.Top.View exposing (view)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Main.Message exposing (Message(..))


view : Html Message
view =
    div
        [ class "top-tool-bar" ]
        []
