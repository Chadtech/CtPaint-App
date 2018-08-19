module Tool.Zoom
    exposing
        ( nextLevelIn
        , nextLevelOut
        , zoom
        )

import Data.Position as Position exposing (Position)


zoom : Int -> Int -> Position -> Position -> Position
zoom oldZoom newZoom centerOfSpace p =
    if newZoom == oldZoom then
        p
    else
        centerOfSpace
            |> Position.subtractFrom p
            |> Position.multiplyBy newZoom
            |> Position.divideBy oldZoom
            |> Position.add centerOfSpace


nextLevelIn : Int -> Int
nextLevelIn zoom =
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


nextLevelOut : Int -> Int
nextLevelOut zoom =
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
