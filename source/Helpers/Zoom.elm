module Helpers.Zoom
    exposing
        ( next
        , pointInMiddle
        , prev
        , repositionAround
        )

import Mouse exposing (Position)
import Window exposing (Size)


repositionAround : Int -> Int -> Position -> Position -> Position
repositionAround oldZoom newZoom canvasPosition target =
    let
        d =
            newZoom - oldZoom

        dx =
            canvasPosition.x - target.x

        dy =
            canvasPosition.y - target.y
    in
    { x = canvasPosition.x - (dx * d)
    , y = canvasPosition.y - (dy * d)
    }


pointInMiddle : Size -> Int -> Position -> Position
pointInMiddle windowSize zoom position =
    let
        middle =
            middleOfScreen windowSize
    in
    { x = (middle.x - position.x) // zoom
    , y = (middle.y - position.y) // zoom
    }


middleOfScreen : Size -> Position
middleOfScreen { width, height } =
    { x = width // 2
    , y = height // 2
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
