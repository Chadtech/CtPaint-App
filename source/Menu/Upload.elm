module Menu.Upload
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
import Menu.Loaded as Loaded
import Menu.Reply exposing (Reply)
import Return2 as R2
import Return3 as R3 exposing (Return)
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


update : Msg -> Model -> Return Model Msg Reply
update msg model =
    case msg of
        UploadFailed problem ->
            Failed problem
                |> R3.withNothing

        GotDataUrl url ->
            Loading
                |> R2.withCmd (loadCmd url)
                |> R3.withNoReply

        LoadedCanvas (Ok canvas) ->
            Loaded canvas
                |> R3.withNothing

        LoadedCanvas (Err err) ->
            Failed CouldNotReadDataUrl
                |> R3.withNothing

        LoadedMsg subMsg ->
            case model of
                Loaded canvas ->
                    model
                        |> R2.withNoCmd
                        |> R3.withReply
                            (Loaded.update subMsg canvas)

                _ ->
                    model
                        |> R3.withNothing


loadCmd : String -> Cmd Msg
loadCmd url =
    url
        |> Canvas.loadImage
        |> Task.attempt LoadedCanvas
