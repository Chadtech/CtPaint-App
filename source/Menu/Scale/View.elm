module Menu.Scale.View exposing (..)

import Html exposing (Html, a, div, form, input, p, text)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Menu.Scale.Types exposing (Message(..), Model)
import MouseEvents as Events
import Util exposing (left, px, top)


view : Model -> Html Message
view model =
    div
        [ class "card scale"
        , style
            [ top model.position.y
            , left model.position.x
            ]
        ]
        [ header
        ]


header : Html Message
header =
    div
        [ class "header"
        , Events.onMouseDown HeaderMouseDown
        ]
        [ p [] [ text "scale" ]
        , a [ onClick CloseClick ] [ text "x" ]
        ]
