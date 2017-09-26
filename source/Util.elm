module Util exposing (..)

import Canvas exposing (Point)
import Color exposing (Color)
import Html exposing (Attribute, Html)
import Html.Events
import Json.Decode as Json
import Mouse exposing (Position)
import ParseInt
import Window exposing (Size)


(:=) : a -> b -> ( a, b )
(:=) =
    (,)


(&) : a -> b -> ( a, b )
(&) =
    (,)


{-| infixl 0 means the (:=) operator has the same precedence as (<|) and (|>),
meaning you can use it at the end of a pipeline and have the precedence work out.
-}
infixl 0 :=


infixl 0 &


pack : a -> b -> ( a, b )
pack =
    (,)


swap : ( a, b ) -> ( b, a )
swap ( a, b ) =
    ( b, a )


maybeCons : Maybe a -> List a -> List a
maybeCons maybe list =
    case maybe of
        Just item ->
            item :: list

        Nothing ->
            list


contains : List a -> a -> Bool
contains =
    flip List.member


groupsOfFour : List a -> List (List a)
groupsOfFour list =
    makeGroupsHelp list [] |> List.reverse


makeGroupsHelp : List a -> List (List a) -> List (List a)
makeGroupsHelp xs res =
    case xs of
        a :: b :: c :: d :: rest ->
            makeGroupsHelp rest ([ a, b, c, d ] :: res)

        [] ->
            res

        _ ->
            xs :: res


slice : Int -> Int -> List a -> List a
slice start end =
    List.drop start >> List.take (end - start)



-- COLOR --


toHex : Color -> String
toHex color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
    [ "#"
    , toHexHelper <| ParseInt.toHex red
    , toHexHelper <| ParseInt.toHex green
    , toHexHelper <| ParseInt.toHex blue
    ]
        |> String.concat


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


onContextMenu : msg -> Attribute msg
onContextMenu msg =
    Html.Events.onWithOptions
        "contextmenu"
        { stopPropagation = False
        , preventDefault = True
        }
        (Json.succeed msg)


viewIf : Bool -> Html msg -> Html msg
viewIf condition html =
    if condition then
        html
    else
        Html.text ""


px : Int -> String
px int =
    toString int ++ "px"


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



-- Tool bar width, a constant used all over the place


tbw : Int
tbw =
    29



-- POSITION AND POINT --


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



-- BOOL --


allTrue : List Bool -> Bool
allTrue =
    List.foldr (&&) True


allFalse : List Bool -> Bool
allFalse =
    List.map not >> allTrue
