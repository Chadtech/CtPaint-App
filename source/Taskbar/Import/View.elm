module Taskbar.Import.View exposing (view)

import Html exposing (Html, div, p, a, form, input, text)
import Html.Attributes exposing (class, style, placeholder, value)
import Html.Events exposing (onSubmit, onClick, onInput)
import Taskbar.Import.Types exposing (Model, Message(..))
import Util exposing (top, left, px)
import MouseEvents as Events


view : Model -> Html Message
view model =
    div
        [ class "card import"
        , style
            [ top model.position.y
            , left model.position.x
            ]
        ]
        [ header
        , form
            [ class "field"
            , onSubmit AttemptLoad
            ]
            [ p [] [ text "url" ]
            , input
                [ onInput UpdateField
                , value model.url
                , placeholder "http://"
                ]
                []
            ]
        , a
            [ class "submit-button"
            , onClick AttemptLoad
            ]
            [ text "import" ]
        ]


header : Html Message
header =
    div
        [ class "header"
        , Events.onMouseDown HeaderMouseDown
        ]
        [ p [] [ text "import" ]
        , a [ onClick CloseClick ] [ text "x" ]
        ]
