module Import exposing (..)

import Canvas exposing (Canvas, Error)
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Helpers.Import
import Html exposing (Html, a, div, form, input, p, text)
import Html.Attributes exposing (class, placeholder, value)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Reply
    exposing
        ( Reply
            ( IncorporateImageAsSelection
            , NoReply
            )
        )


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
    | LoadingText
    | FailText


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
    , Css.class LoadingText
        [ textAlign center
        , marginTop (px 8)
        ]
    , Css.class FailText
        [ textAlign center
        , marginBottom (px 8)
        ]
    ]
        |> namespace importNamespace
        |> stylesheet


importNamespace : String
importNamespace =
    Html.Custom.makeNamespace "Import"



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
        [ class [ FailText ] ]
        [ Html.text "Sorry, I couldnt load that image" ]
    , Html.Custom.menuButton
        [ onClick TryAgainPressed ]
        [ Html.text "try again" ]
    ]


loadingView : List (Html Msg)
loadingView =
    [ Html.Custom.spinner []
    , p
        [ class [ LoadingText ] ]
        [ Html.text "Loading.." ]
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


update : Msg -> Model -> ( Model, Cmd Msg, Reply )
update msg model =
    case msg of
        FieldUpdated str ->
            case model of
                Url _ ->
                    Reply.nothing (Url str)

                _ ->
                    Reply.nothing model

        ImportPressed ->
            attemptLoad model

        Submitted ->
            attemptLoad model

        ImageLoaded (Ok canvas) ->
            ( model
            , Cmd.none
            , IncorporateImageAsSelection canvas
            )

        ImageLoaded (Err err) ->
            Reply.nothing Fail

        TryAgainPressed ->
            Reply.nothing init


attemptLoad : Model -> ( Model, Cmd Msg, Reply )
attemptLoad model =
    case model of
        Url url ->
            sendLoadCmd url

        _ ->
            Reply.nothing model


sendLoadCmd : String -> ( Model, Cmd Msg, Reply )
sendLoadCmd url =
    ( Loading
    , Helpers.Import.loadCmd url ImageLoaded
    , NoReply
    )
