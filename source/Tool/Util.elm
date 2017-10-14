module Tool.Util exposing (adjustPosition)

import Mouse exposing (Position)
import Types exposing (Model)


adjustPosition : Model -> Int -> Position -> Position
adjustPosition { canvas, canvasPosition, zoom } offset position =
    let
        x =
            List.sum
                [ position.x
                , -canvasPosition.x
                , -offset
                ]

        y =
            List.sum
                [ position.y
                , -canvasPosition.y
                , -offset
                ]
    in
    { x = x // zoom, y = y // zoom }


nextZoom : Int -> Int
nextZoom zoom =
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


prevZoom : Int -> Int
prevZoom zoom =
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
