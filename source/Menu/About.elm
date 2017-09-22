module Menu.About exposing (view)

import Html exposing (Html, a, div, p)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Menu exposing (Msg(..))


view : Html Msg
view =
    div
        [ class "card about" ]
        []
