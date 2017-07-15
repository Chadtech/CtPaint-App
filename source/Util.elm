module Util exposing (..)

import Canvas exposing (Point)
import Mouse exposing (Position)


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



-- POSITION AND POINT --


toPosition : Point -> Position
toPosition { x, y } =
    Position (floor x) (floor y)


toPoint : Position -> Point
toPoint { x, y } =
    Point (toFloat x) (toFloat y)
