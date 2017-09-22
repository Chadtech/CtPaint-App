module Download exposing (..)

import Array exposing (Array)
import Random exposing (Generator, Seed)


type Msg
    = UpdateField String
    | Submit


type alias Model =
    { content : String
    , placeholder : String
    }


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
