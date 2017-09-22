module Menu.Text.View exposing (view)

--import Html.Events exposing (onClick, onSubmit)

import Html exposing (Html, a, br, div, form, input, p, text)
import Html.Attributes exposing (class, placeholder, style)
import Menu.Text.Types exposing (Model, Msg(..))


--import MouseEvents as Events
--import Util exposing (left, px, top)


view : Model -> Html Msg
view model =
    div
        [ class "card text-menu" ]
        []
