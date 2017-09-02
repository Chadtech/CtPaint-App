module Taskbar.Download.View exposing (view)

import Html exposing (Html, div, p, a, form, input, text)
import Html.Attributes exposing (class, style, placeholder, value)
import Html.Events exposing (onSubmit, onClick, onInput)
import Taskbar.Download.Types exposing (Model, Message(..))
import Util exposing (top, left, px)


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
        [ class "header" ]
        [ p [] [ text "download" ]
        , a [ onClick CloseClick ] [ text "x" ]
        ]
