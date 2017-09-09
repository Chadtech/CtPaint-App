module Menu.Download.View exposing (view)

import Html exposing (Html, a, div, form, input, p, text)
import Html.Attributes exposing (class, placeholder, style, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Menu.Download.Types exposing (Message(..), Model)
import MouseEvents as Events
import Util exposing (left, px, top)


view : Model -> Html Message
view model =
    div
        [ class "card download"
        , style
            [ top model.position.y
            , left model.position.x
            ]
        ]
        [ header
        , form
            [ class "field"
            , onSubmit Submit
            ]
            [ p [] [ text "file name" ]
            , input
                [ onInput UpdateField
                , value model.content
                , placeholder model.placeholder
                ]
                []
            ]
        , a
            [ class "submit-button"
            , onClick Submit
            ]
            [ text "download" ]
        ]


header : Html Message
header =
    div
        [ class "header"
        , Events.onMouseDown HeaderMouseDown
        ]
        [ p [] [ text "download" ]
        , a [ onClick CloseClick ] [ text "x" ]
        ]
