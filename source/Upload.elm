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
import Html.Events exposing (onClick)
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
    = Text
    | LoadingText
    | FailText
    | CanvasContainer
    | UploadedCanvas
    | ButtonsContainer
    | Button


css : Stylesheet
css =
    [ Css.class Text
        [ maxWidth (px 500)
        , marginBottom (px 8)
        ]
    , (Css.class CanvasContainer << List.append Html.Custom.indent)
        [ marginBottom (px 8) ]
    , Css.class UploadedCanvas
        [ maxWidth (px 500)
        , property "image-rendering" "auto"
        ]
    , Css.class LoadingText
        [ textAlign center
        , marginTop (px 8)
        ]
    , Css.class FailText
        [ textAlign center
        , marginBottom (px 8)
        ]
    , Css.class ButtonsContainer
        [ textAlign center ]
    , Css.class Button
        [ display inlineBlock
        , marginRight (px 8)
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
    [ div
        [ class [ CanvasContainer ] ]
        [ Canvas.toHtml
            [ class [ UploadedCanvas ] ]
            canvas
        ]
    , p
        [ class [ Text ] ]
        [ Html.text "Would you like to bring this in as a selection, or just replace the whole canvas with your upload? Replacing the canvas will whip out the current state of the canvas." ]
    , buttons
    ]


buttons : Html Msg
buttons =
    div
        [ class [ ButtonsContainer ] ]
        [ Html.Custom.menuButton
            [ class [ Button ]
            , onClick AsSelectionClicked
            ]
            [ Html.text "load as selecton" ]
        , Html.Custom.menuButton
            [ class [ Button ]
            , onClick AsCanvasClicked
            ]
            [ Html.text "load as canvas" ]
        ]


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
