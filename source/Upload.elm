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
import Chadtech.Colors as Ct
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
    | Error


css : Stylesheet
css =
    [ Css.class Text
        [ maxWidth (px 500)
        , marginBottom (px 8)
        ]
    , Css.class LoadingText
        [ textAlign center
        , marginBottom (px 8)
        ]
    , Css.class FailText
        [ textAlign center
        , marginBottom (px 8)
        ]
    , Css.class Error
        [ backgroundColor Ct.lowWarning ]
    ]
        |> namespace uploadNamespace
        |> stylesheet


uploadNamespace : String
uploadNamespace =
    Html.Custom.makeNamespace "Upload"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace uploadNamespace


view : Model -> Html Msg
view model =
    case model of
        Loading ->
            loadingView

        Loaded canvas ->
            canvas
                |> Loaded.view
                |> Html.map LoadedMsg

        Failed problem ->
            failedView problem


loadingView : Html Msg
loadingView =
    [ Html.Custom.spinner [] ]
        |> Html.Custom.cardBody []


failedView : Problem -> Html Msg
failedView problem =
    [ p
        [ class [ FailText ] ]
        [ Html.text failText ]
    ]
        |> Html.Custom.cardBody [ class [ Error ] ]


failText : String
failText =
    """
    I couldnt load your image. Either
    something is wrong with your image
    or Im broken.
    """



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
