module Menu.Scale.View exposing (..)

import Html exposing (Html, a, br, div, form, input, p, text)
import Html.Attributes exposing (class, placeholder, style)
import Html.Events exposing (onClick, onSubmit)
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
        , div
            [ class "main-body" ]
            [ leftSide model
            , rightSide model
            , form
                [ class "field ratio" ]
                [ p [] [ text "Lock" ]
                , input [] []
                ]
            , div
                [ class "buttons-container" ]
                [ a
                    []
                    [ text "Set Size" ]
                , a
                    []
                    [ text "Cancel" ]
                ]
            ]
        ]


rightSide : Model -> Html Message
rightSide { initialSize } =
    div
        [ class "column" ]
        [ p [] [ text "Percent" ]
        , field
            [ p [] [ text "width" ]
            , input
                [ placeholder "100%" ]
                []
            ]
        , field
            [ p [] [ text "height" ]
            , input
                [ placeholder "100%" ]
                []
            ]
        ]


leftSide : Model -> Html Message
leftSide { initialSize } =
    div
        [ class "column" ]
        [ p [] [ text "Absolute" ]
        , field
            [ p [] [ text "width" ]
            , input
                [ placeholder
                    (toString initialSize.width ++ "px")
                ]
                []
            ]
        , field
            [ p [] [ text "height" ]
            , input
                [ placeholder
                    (toString initialSize.height ++ "px")
                ]
                []
            ]
        ]


field : List (Html Message) -> Html Message
field =
    form [ class "field", onSubmit SetSize ]


header : Html Message
header =
    div
        [ class "header"
        , Events.onMouseDown HeaderMouseDown
        ]
        [ p [] [ text "scale" ]
        , a [ onClick CloseClick ] [ text "x" ]
        ]
