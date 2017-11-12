module Import exposing (..)

import Canvas exposing (Canvas, Error)
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Html exposing (Html, a, div, form, input, p, text)
import Html.Attributes exposing (class, placeholder, value)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Reply exposing (Reply(IncorporateImage, NoReply))
import Task
import Tuple.Infix exposing ((&))


-- TYPES --


type Msg
    = FieldUpdated String
    | ImportPressed
    | Submitted
    | ImageLoaded (Result Error Canvas)
    | TryAgainPressed


type Model
    = Url String
    | Loading
    | Fail



-- STYLES --


type Class
    = Field


css : Stylesheet
css =
    [ Css.class Field
        [ children
            [ Css.Elements.input
                [ width (px 360) ]
            , Css.Elements.p
                [ width (px 40) ]
            ]
        ]
    ]
        |> namespace importNamespace
        |> stylesheet


importNamespace : String
importNamespace =
    "Import"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace importNamespace


normalView : String -> List (Html Msg)
normalView str =
    [ Html.Custom.field
        [ class [ Field ]
        , onSubmit Submitted
        ]
        [ p [] [ Html.text "url" ]
        , input
            [ onInput FieldUpdated
            , value str
            , placeholder "http://"
            ]
            []
        ]
    , Html.Custom.menuButton
        [ onClick ImportPressed ]
        [ Html.text "import" ]
    ]


errorView : List (Html Msg)
errorView =
    [ p
        []
        [ Html.text "Sorry, I couldnt load that image" ]
    , Html.Custom.menuButton
        [ onClick TryAgainPressed ]
        [ Html.text "Try Again" ]
    ]


loadingView : List (Html Msg)
loadingView =
    [ p [] [ Html.text "Loading.." ] ]


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


update : Msg -> Model -> ( ( Model, Cmd Msg ), Reply )
update msg model =
    case msg of
        FieldUpdated str ->
            case model of
                Url _ ->
                    Url str & Cmd.none & NoReply

                _ ->
                    model & Cmd.none & NoReply

        ImportPressed ->
            attemptLoad model

        Submitted ->
            attemptLoad model

        ImageLoaded (Ok canvas) ->
            model
                & Cmd.none
                & IncorporateImage canvas

        ImageLoaded (Err err) ->
            Fail & Cmd.none & NoReply

        TryAgainPressed ->
            init & Cmd.none & NoReply


attemptLoad : Model -> ( ( Model, Cmd Msg ), Reply )
attemptLoad model =
    case model of
        Url url ->
            sendLoadCmd url

        _ ->
            model & Cmd.none & NoReply


sendLoadCmd : String -> ( ( Model, Cmd Msg ), Reply )
sendLoadCmd url =
    let
        cmd =
            [ "https://cors-anywhere.herokuapp.com/"
            , url
            ]
                |> String.concat
                |> Canvas.loadImage
                |> Task.attempt ImageLoaded
    in
    Loading & cmd & NoReply
