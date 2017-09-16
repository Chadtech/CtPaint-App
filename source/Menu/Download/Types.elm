module Menu.Download.Types exposing (..)

import Array exposing (Array)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Random exposing (Generator, Seed)
import Window exposing (Size)


type Msg
    = UpdateField String
    | CloseClick
    | Submit
    | HeaderMouseDown MouseEvent
    | HeaderMouseMove Position
    | HeaderMouseUp


type ExternalMsg
    = DoNothing
    | DownloadFile String
    | Close


type alias Model =
    { content : String
    , placeholder : String
    , position : Position
    , clickState : Maybe Position
    }


init : Maybe String -> Seed -> Size -> ( Model, Seed )
init maybeProjectName seed size =
    case maybeProjectName of
        Just projectName ->
            ( fromString size projectName, seed )

        Nothing ->
            fromSeed size seed


fromSeed : Size -> Seed -> ( Model, Seed )
fromSeed size =
    Random.step projectNameGenerator
        >> Tuple.mapFirst (fromString size)


fromString : Size -> String -> Model
fromString size projectName =
    { content = ""
    , placeholder = projectName
    , position =
        { x = (size.width // 2) - 208
        , y = (size.height // 2) - 50
        }
    , clickState = Nothing
    }


projectNameGenerator : Generator String
projectNameGenerator =
    Random.int 0 61
        |> Random.list 10
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
    [ "0123456789"
    , "abcdefghijklmnopqrstuvwxyz"
    , "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    ]
        |> String.concat
        |> String.toList
        |> Array.fromList
