module Import exposing (..)

import Canvas exposing (Canvas, Error)
import Html exposing (Html, a, div, form, input, p, text)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Task
import Util exposing ((&))


-- TYPES --


type Msg
    = UpdateField String
    | AttemptLoad
    | ImageLoaded (Result Error Canvas)
    | TryAgain


type ExternalMsg
    = Cmd (Cmd Msg)
    | IncorporateImage Canvas
    | DoNothing


type Model
    = Url String
    | Loading
    | Fail



-- VIEW --


normalView : String -> List (Html Msg)
normalView str =
    [ form
        [ class "field import"
        , onSubmit AttemptLoad
        ]
        [ p [] [ text "url" ]
        , input
            [ onInput UpdateField
            , value str
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


errorView : List (Html Msg)
errorView =
    [ div
        [ class "text-container" ]
        [ p
            []
            [ text "Sorry, I couldnt load that image" ]
        ]
    , a
        [ onClick TryAgain
        , class "submit-button"
        ]
        [ text "Try Again" ]
    ]


loadingView : List (Html Msg)
loadingView =
    [ div
        [ class "text-container" ]
        [ p [] [ text "Loading.." ] ]
    ]


view : Model -> List (Html Msg)
view model =
    case model of
        Url str ->
            normalView str

        Loading ->
            loadingView

        Fail ->
            errorView



-- INIT --


init : Model
init =
    Url ""



-- UPDATE --


update : Msg -> Model -> ( Model, ExternalMsg )
update msg model =
    case msg of
        UpdateField str ->
            Url str & DoNothing

        AttemptLoad ->
            case model of
                Url str ->
                    attemptLoad str

                _ ->
                    model & DoNothing

        ImageLoaded (Ok canvas) ->
            model & IncorporateImage canvas

        ImageLoaded (Err err) ->
            Fail & DoNothing

        TryAgain ->
            Url "" & DoNothing


attemptLoad : String -> ( Model, ExternalMsg )
attemptLoad url =
    let
        cmd =
            [ "https://cors-anywhere.herokuapp.com/"
            , url
            ]
                |> String.concat
                |> Canvas.loadImage
                |> Task.attempt ImageLoaded
    in
    Loading & Cmd cmd
