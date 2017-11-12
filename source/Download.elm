module Download exposing (..)

import Array exposing (Array)
import Html exposing (Html, a, form, input, p, text)
import Html.Attributes exposing (class, placeholder, value)
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Ports exposing (JsMsg(Download))
import Random exposing (Generator, Seed)
import Tuple.Infix exposing ((&))


type Msg
    = FieldUpdated String
    | Submitted
    | DownloadButtonPressed


type alias Model =
    { field : String
    , placeholder : String
    }



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FieldUpdated str ->
            { model | field = str } & Cmd.none

        Submitted ->
            model & download model

        DownloadButtonPressed ->
            model & download model


download : Model -> Cmd Msg
download =
    fileName >> Download >> Ports.send


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
            fromSeed seed


fromSeed : Seed -> ( Model, Seed )
fromSeed =
    Random.step projectNameGenerator
        >> Tuple.mapFirst fromString


fromString : String -> Model
fromString projectName =
    { field = ""
    , placeholder = projectName
    }



-- RANDOM NAME GENERATION --


projectNameGenerator : Generator String
projectNameGenerator =
    Random.int 0 61
        |> Random.list 16
        |> Random.map listIntToString


listIntToString : List Int -> String
listIntToString =
    List.map (toChar >> String.fromChar)
        >> String.concat


toChar : Int -> Char
toChar int =
    case Array.get int alphanumeric of
        Just char ->
            char

        Nothing ->
            'w'


alphanumeric : Array Char
alphanumeric =
    [ "0123456789"
    , "abcdefghijklmnopqrstuvwxyz"
    , "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    ]
        |> String.concat
        |> String.toList
        |> Array.fromList
