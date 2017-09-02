module Taskbar.Download.Types exposing (..)

import Random exposing (Seed, Generator)
import Array exposing (Array)
import Window exposing (Size)
import Mouse exposing (Position)


type Message
    = UpdateField String
    | CloseClick
    | Submit


type ExternalMessage
    = DoNothing
    | Close


type alias Model =
    { content : String
    , placeholder : String
    , position : Position
    }


initFromSeed : Size -> Seed -> ( Model, Seed )
initFromSeed size =
    Random.step projectNameGenerator
        >> Tuple.mapFirst (initFromString size)


initFromString : Size -> String -> Model
initFromString size projectName =
    { content = ""
    , placeholder = projectName
    , position = Position 50 50
    }


projectNameGenerator : Generator String
projectNameGenerator =
    Random.list 10 (Random.int 0 61)
        |> Random.map toString


toString : List Int -> String
toString =
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
    "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        |> String.toList
        |> Array.fromList
