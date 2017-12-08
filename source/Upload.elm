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
import Html exposing (Html, p)
import Html.CssHelpers
import Html.Custom
import Reply
    exposing
        ( Reply
            ( IncorporateImageAsCanvas
            , IncorporateImageAsSelection
            , NoReply
            )
        )
import Task
import Tuple.Infix exposing ((&), (|&))


-- TYPES --


type Msg
    = UploadFailed Problem
    | GotDataUrl String
    | LoadedCanvas (Result Canvas.Error Canvas)
    | AsSelectionClicked
    | AsCanvasClicked


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
    = LoadingText
    | FailText


css : Stylesheet
css =
    [ Css.class LoadingText
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
            loadedView canvas

        Failed problem ->
            failedView problem


loadingView : List (Html Msg)
loadingView =
    [ Html.Custom.spinner []
    , p
        [ class [ LoadingText ] ]
        [ Html.text "Loading.." ]
    ]


loadedView : Canvas -> List (Html Msg)
loadedView canvas =
    []


failedView : Problem -> List (Html Msg)
failedView problem =
    []



-- UPDATE --


update : Msg -> Model -> ( ( Model, Cmd Msg ), Reply )
update msg model =
    case msg of
        UploadFailed problem ->
            Failed problem & Cmd.none & NoReply

        GotDataUrl url ->
            url
                |> Canvas.loadImage
                |> Task.attempt LoadedCanvas
                |& Loading
                & NoReply

        LoadedCanvas (Ok canvas) ->
            Loaded canvas & Cmd.none & NoReply

        LoadedCanvas (Err err) ->
            Failed CouldNotReadDataUrl & Cmd.none & NoReply

        AsSelectionClicked ->
            case model of
                Loaded canvas ->
                    model
                        & Cmd.none
                        & IncorporateImageAsSelection canvas

                _ ->
                    model & Cmd.none & NoReply

        AsCanvasClicked ->
            case model of
                Loaded canvas ->
                    model
                        & Cmd.none
                        & IncorporateImageAsCanvas canvas

                _ ->
                    model & Cmd.none & NoReply
