module Download exposing (..)

import Html exposing (Html, a, form, input, p, text)
import Html.Attributes exposing (class, placeholder, value)
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Ports exposing (JsMsg(Download))
import Random exposing (Generator, Seed)
import Reply exposing (Reply(CloseMenu, NoReply))
import Tuple.Infix exposing ((&), (|&))
import Util


type Msg
    = FieldUpdated String
    | Submitted
    | DownloadButtonPressed


type alias Model =
    { field : String
    , placeholder : String
    }



-- UPDATE --


update : Msg -> Model -> ( ( Model, Cmd Msg ), Reply )
update msg model =
    case msg of
        FieldUpdated str ->
            { model | field = str }
                & Cmd.none
                & NoReply

        Submitted ->
            download model

        DownloadButtonPressed ->
            download model


download : Model -> ( ( Model, Cmd Msg ), Reply )
download model =
    model
        |> fileName
        |> Download
        |> Ports.send
        |& model
        & CloseMenu


fileName : Model -> String
fileName { field, placeholder } =
    case field of
        "" ->
            placeholder

        _ ->
            field



-- VIEW --


view : Model -> List (Html Msg)
view model =
    [ Html.Custom.field
        [ onSubmit Submitted
        ]
        [ p [] [ Html.text "file name" ]
        , input
            [ onInput FieldUpdated
            , value model.field
            , placeholder model.placeholder
            ]
            []
        ]
    , Html.Custom.menuButton
        [ onClick DownloadButtonPressed ]
        [ Html.text "download" ]
    ]



-- INIT --


init : Maybe String -> Seed -> ( Model, Seed )
init maybeProjectName seed =
    case maybeProjectName of
        Just projectName ->
            ( fromString projectName, seed )

        Nothing ->
            Util.uuid seed 16
                |> Tuple.mapFirst fromString


fromString : String -> Model
fromString projectName =
    { field = ""
    , placeholder = projectName
    }
