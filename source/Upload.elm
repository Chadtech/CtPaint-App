module Upload
    exposing
        ( Model
        , Msg(..)
        , Problem(..)
        , css
        , init
        , update
        , view
        )

import Canvas exposing (Canvas)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, div, p)
import Html.CssHelpers
import Html.Custom
import Html.Loaded as Loaded
import Reply exposing (Reply(NoReply))
import Task


-- TYPES --


type Msg
    = UploadFailed Problem
    | GotDataUrl String
    | LoadedCanvas (Result Canvas.Error Canvas)
    | LoadedMsg Loaded.Msg


type Problem
    = Other String
    | CouldNotReadDataUrl
    | FileNotImage


type Model
    = Loading
    | Loaded Canvas
    | Failed Problem


init : Model
init =
    Loading



-- STYLES --


type Class
    = Text
    | LoadingText
    | FailText


css : Stylesheet
css =
    [ Css.class Text
        [ maxWidth (px 500)
        , marginBottom (px 8)
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
        |> namespace uploadNamespace
        |> stylesheet


uploadNamespace : String
uploadNamespace =
    Html.Custom.makeNamespace "Upload"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace uploadNamespace


view : Model -> List (Html Msg)
view model =
    case model of
        Loading ->
            loadingView

        Loaded canvas ->
            canvas
                |> Loaded.view
                |> List.map (Html.map LoadedMsg)

        Failed problem ->
            failedView problem


loadingView : List (Html Msg)
loadingView =
    [ Html.Custom.spinner []
    , p
        [ class [ LoadingText ] ]
        [ Html.text "Loading.." ]
    ]


failedView : Problem -> List (Html Msg)
failedView problem =
    []



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg, Reply )
update msg model =
    case msg of
        UploadFailed problem ->
            Failed problem
                |> Reply.nothing

        GotDataUrl url ->
            ( Loading
            , url
                |> Canvas.loadImage
                |> Task.attempt LoadedCanvas
            , NoReply
            )

        LoadedCanvas (Ok canvas) ->
            Loaded canvas
                |> Reply.nothing

        LoadedCanvas (Err err) ->
            Failed CouldNotReadDataUrl
                |> Reply.nothing

        LoadedMsg subMsg ->
            case model of
                Loaded canvas ->
                    ( model
                    , Cmd.none
                    , Loaded.update subMsg canvas
                    )

                _ ->
                    model
                        |> Reply.nothing
