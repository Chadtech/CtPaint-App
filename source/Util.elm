module Util exposing (..)

import Canvas exposing (Point)
import Mouse exposing (Position)
import Window exposing (Size)


(:=) : a -> b -> ( a, b )
(:=) =
    (,)


{-| infixl 0 means the (:=) operator has the same precedence as (<|) and (|>),
meaning you can use it at the end of a pipeline and have the precedence work out.
-}
infixl 0 :=


maybeCons : Maybe a -> List a -> List a
maybeCons maybe list =
    case maybe of
        Just item ->
            item :: list

        Nothing ->
            list



-- HTML STYLE --


px : Int -> String
px int =
    (toString int) ++ "px"


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
