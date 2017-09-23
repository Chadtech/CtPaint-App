port module Download exposing (..)

import Array exposing (Array)
import Html exposing (Html, a, form, input, p, text)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onClick, onInput, onSubmit)
import Random exposing (Generator, Seed)
import Util exposing ((&))


type Msg
    = UpdateField String
    | Submit


type alias Model =
    { content : String
    , placeholder : String
    }



-- PORTS --


port download : String -> Cmd msg



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateField field ->
            { model | content = field } & Cmd.none

        Submit ->
            let
                fileName =
                    case model.content of
                        "" ->
                            model.placeholder

                        content ->
                            content
            in
            model & download fileName



-- VIEW --


view : Model -> List (Html Msg)
view model =
    [ form
        [ class "field"
        , onSubmit Submit
        ]
        [ p [] [ text "file name" ]
        , input
            [ onInput UpdateField
            , value model.content
            , placeholder model.placeholder
            ]
            []
        ]
    , a
        [ class "submit-button"
        , onClick Submit
        ]
        [ text "download" ]
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
    { content = ""
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
