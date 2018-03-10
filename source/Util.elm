module Util exposing (..)

import Array exposing (Array)
import Canvas exposing (Canvas, Point)
import Color exposing (Color)
import Html exposing (Attribute, Html)
import Html.Attributes exposing (style, value)
import Html.Events
import Id exposing (Origin(Local, Remote))
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Mouse exposing (Position)
import ParseInt
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



-- COLOR --


toHexColor : Color -> String
toHexColor color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
    [ "#"
    , toHex red
    , toHex green
    , toHex blue
    ]
        |> String.concat


toHex : Int -> String
toHex =
    ParseInt.toHex >> toHexHelper


toHexHelper : String -> String
toHexHelper hex =
    if String.length hex > 1 then
        hex
    else
        "0" ++ hex


toColor : String -> Maybe Color
toColor colorMaybe =
    if 6 == String.length colorMaybe then
        let
            r =
                String.slice 0 2 colorMaybe
                    |> ParseInt.parseIntHex

            g =
                String.slice 2 4 colorMaybe
                    |> ParseInt.parseIntHex

            b =
                String.slice 4 6 colorMaybe
                    |> ParseInt.parseIntHex
        in
        case ( r, g, b ) of
            ( Ok red, Ok green, Ok blue ) ->
                Just (Color.rgb red green blue)

            _ ->
                Nothing
    else
        Nothing



-- HTML --


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


onContextMenu : msg -> Attribute msg
onContextMenu msg =
    Html.Events.onWithOptions
        "contextmenu"
        { stopPropagation = False
        , preventDefault = True
        }
        (Decode.succeed msg)


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


background : Color -> Attribute msg
background =
    toHexColor
        >> (,) "background"
        >> List.singleton
        >> style



-- Tool bar width, a constant used all over the place


tbw : Int
tbw =
    floor toolbarWidth



-- palette bar height


pbh : Int
pbh =
    58


toolbarWidth : Float
toolbarWidth =
    29



-- POSITION AND POINT --


center : Size -> Size -> Position
center windowSize size =
    { x =
        ((windowSize.width - tbw) - size.width) // 2
    , y =
        (windowSize.height - size.height) // 2
    }


middle : Size -> Position
middle { width, height } =
    { x = width // 2
    , y = height // 2
    }


toSize : Position -> Position -> Size
toSize p q =
    let
        minPos =
            positionMin p q

        maxPos =
            positionMax p q
    in
    Size
        (maxPos.x - minPos.x + 1)
        (maxPos.y - minPos.y + 1)


positionMin : Position -> Position -> Position
positionMin p q =
    Position (min p.x q.x) (min p.y q.y)


positionMax : Position -> Position -> Position
positionMax p q =
    Position (max p.x q.x) (max p.y q.y)


toPosition : Point -> Position
toPosition { x, y } =
    Position (floor x) (floor y)


toPoint : Position -> Point
toPoint { x, y } =
    Point (toFloat x) (toFloat y)



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


mixinCmd : Cmd msg -> ( model, Cmd msg ) -> ( model, Cmd msg )
mixinCmd newCmd ( model, cmd ) =
    ( model
    , Cmd.batch [ newCmd, cmd ]
    )


delay : Time -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity
