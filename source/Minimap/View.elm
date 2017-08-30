module Minimap.View exposing (view)

import Html exposing (Html, div, p, a)
import Minimap.Types exposing (Model, Message(..))


view : Model -> Html Message
view model =
    div
        [ class "mini-map" ]
        []
