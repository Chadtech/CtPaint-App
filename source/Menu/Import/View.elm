module Menu.Import.View exposing (view)

import Html exposing (Html, a, div, form, input, p, text)
import Html.Attributes exposing (class, placeholder, style, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Menu.Import.Types exposing (Message(..), Model)
import MouseEvents as Events
import Util exposing (left, px, top, viewIf)


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
            , viewIf
                model.error
                (p [] [ text " Error ! " ])
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
