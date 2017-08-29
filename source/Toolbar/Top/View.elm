module Toolbar.Top.View exposing (view)

import Html exposing (Html, Attribute, div, a, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Main.Model exposing (Model)
import Toolbar.Top.Types exposing (Option(..), Message(..))


view : Model -> Html Message
view model =
    div
        [ class "top-tool-bar" ]
        [ file model.taskbarDropped
        , a
            [ class "task-bar-button"
            , onClick (DropDown (Just Edit))
            ]
            [ text "Edit" ]
        ]


file : Maybe Option -> Html Message
file maybeFile =
    case maybeFile of
        Just File ->
            a
                [ class "task-bar-button"
                , onClick (DropDown Nothing)
                ]
                [ text "File"
                , div
                    [ class "seam" ]
                    []
                , div
                    [ class "options" ]
                    [ option
                        []
                        [ p [] [ text "Download" ]
                        , cmd "Cmd + D"
                        ]
                    , option
                        []
                        [ p [] [ text "Import" ]
                        , cmd "Cmd + I"
                        ]
                    , divider
                    , option
                        []
                        [ p [] [ text "Imgur" ] ]
                    , option
                        []
                        [ p [] [ text "Twitter" ] ]
                    ]
                ]

        _ ->
            a
                [ class "task-bar-button"
                , onClick (DropDown (Just File))
                ]
                [ text "File" ]


divider : Html Message
divider =
    div
        [ class "divider" ]
        [ div [ class "strike" ] [] ]


option : List (Attribute Message) -> List (Html Message) -> Html Message
option attr =
    div (attr ++ [ class "option" ])


cmd : String -> Html Message
cmd keyStr =
    p [ class "cmd" ] [ text keyStr ]



--show : Html Message -> List (Html Message) -> List (Html Message)
