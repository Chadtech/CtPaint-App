module Util exposing (..)

import Array exposing (Array)
import Canvas exposing (Canvas, Point)
import Color exposing (Color)
import Html exposing (Attribute, Html)
import Html.Attributes exposing (style, value)
import Html.Events exposing (keyCode, on)
import Id exposing (Origin(Local, Remote))
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Process
import Random.Pcg as Random
    exposing
        ( Generator
        , Seed
        )
import Task
import Time exposing (Time)
import Window exposing (Size)


type ClickState
    = NoClick
    | ClickAt Mouse.Position


def : a -> b -> ( a, b )
def =
    (,)


withIndex : List a -> List ( Int, a )
withIndex =
    List.indexedMap (,)


maybeCons : Maybe a -> List a -> List a
maybeCons maybe list =
    case maybe of
        Just item ->
            item :: list

        Nothing ->
            list


encodeOrigin : Origin -> Value
encodeOrigin origin =
    case origin of
        Remote id ->
            Id.encode id

        Local ->
            Encode.null



-- STRING --


replace : String -> String -> String -> String
replace target replacement str =
    str
        |> String.split target
        |> String.join replacement



-- NUMBER --


filterNan : Float -> Float
filterNan fl =
    if isNaN fl then
        0
    else
        fl



-- HTML --


onEnter : msg -> Attribute msg
onEnter msg =
    on "keydown"
        (keyCode |> Decode.andThen (enterDecoder msg))


enterDecoder : msg -> Int -> Decoder msg
enterDecoder msg keyCode =
    case keyCode of
        13 ->
            Decode.succeed msg

        _ ->
            Decode.fail "Not enter key"


valueIfFocus : field -> Maybe field -> String -> Attribute msg
valueIfFocus thisField maybeFocusedField str =
    case maybeFocusedField of
        Just focusedField ->
            if thisField == focusedField then
                value str
            else
                value ""

        Nothing ->
            value ""


viewIf : Bool -> Html msg -> Html msg
viewIf condition html =
    if condition then
        html
    else
        Html.text ""


showField : Bool -> String -> String
showField condition str =
    if condition then
        str
    else
        "********"


px : Int -> String
px int =
    toString int ++ "px"


pct : Float -> String
pct float =
    toString (floor float) ++ "%"


left : Int -> ( String, String )
left =
    px >> (,) "left"


top : Int -> ( String, String )
top =
    px >> (,) "top"


width : Int -> ( String, String )
width =
    px >> (,) "width"


height : Int -> ( String, String )
height =
    px >> (,) "height"



-- RANDOM --


alphanumeric : Array Char
alphanumeric =
    [ "0123456789"
    , "abcdefghijklmnopqrstuvwxyz"
    , "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    ]
        |> String.concat
        |> String.toList
        |> Array.fromList


uuid : Seed -> Int -> ( String, Seed )
uuid seed length_ =
    Random.step (uuidGenerator length_) seed


uuidGenerator : Int -> Generator String
uuidGenerator length_ =
    Random.int 0 61
        |> Random.list length_
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



-- CMD --


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity
