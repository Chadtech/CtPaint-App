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
        (determineView model)


determineView : Model -> List (Html Message)
determineView model =
    if model.error then
        errorView model
    else
        normalView model


errorView : Model -> List (Html Message)
errorView model =
    [ header
    , div
        [ class "text-container" ]
        [ p
            []
            [ text "Sorry, we couldnt load that image" ]
        ]
    , div
        [ class "buttons-container" ]
        [ a
            [ onClick TryAgain ]
            [ text "Try Again" ]
        , a
            [ onClick CloseClick ]
            [ text "Close" ]
        ]
    ]


normalView : Model -> List (Html Message)
normalView model =
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
