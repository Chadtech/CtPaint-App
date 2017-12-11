module Helpers.Zoom
    exposing
        ( next
        , pointInMiddle
        , prev
        )

import Mouse exposing (Position)
import Util
import Window exposing (Size)


{-|

    Given the current window size, zoom level, and canvas position,
    what is the position on the canvas in that is in the middle of
    the screen?

-}
pointInMiddle : Size -> Int -> Position -> Position
pointInMiddle windowSize zoom position =
    let
        middle =
            Util.middle windowSize
    in
    { x = (middle.x - position.x) // zoom
    , y = (middle.y - position.y) // zoom
    }


next : Int -> Int
next zoom =
    case zoom of
        1 ->
            2

        2 ->
            3

        3 ->
            4

        4 ->
            6

        6 ->
            8

        8 ->
            12

        12 ->
            16

        16 ->
            24

        _ ->
            zoom


prev : Int -> Int
prev zoom =
    case zoom of
        2 ->
            1

        3 ->
            2

        4 ->
            3

        6 ->
            4

        8 ->
            6

        12 ->
            8

        16 ->
            12

        24 ->
            16

        _ ->
            zoom
