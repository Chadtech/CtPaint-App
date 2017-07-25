module Tool.Zoom exposing (..)

import Mouse exposing (Position)
import Main.Model exposing (Model)
import Mouse exposing (Position)
import Canvas exposing (Size)
import Util exposing (tbw)


adjust : Position -> Int -> Model -> Model
adjust { x, y } bias ({ zoom, windowSize, canvasPosition } as model) =
    let
        halfWindowSize =
            Size
                ((windowSize.width - tbw) // 2)
                ((windowSize.height - tbw) // 2)

        x_ =
            (x - halfWindowSize.width) // zoom

        y_ =
            (y - halfWindowSize.height) // zoom
    in
        { model
            | canvasPosition =
                Position
                    (canvasPosition.x + (x_ * bias))
                    (canvasPosition.y + (y_ * bias))
        }


set : Int -> Model -> Model
set zoom ({ canvas, canvasPosition, windowSize } as model) =
    let
        canvasSize =
            Canvas.getSize canvas

        halfWindowSize =
            Size
                ((windowSize.width - tbw) // 2)
                ((windowSize.height - tbw) // 2)

        relZoom : Int -> Int
        relZoom d =
            d * zoom // model.zoom

        x =
            halfWindowSize.width
                |> (-) canvasPosition.x
                |> relZoom
                |> (+) halfWindowSize.width

        y =
            halfWindowSize.height
                |> (-) canvasPosition.y
                |> relZoom
                |> (+) halfWindowSize.height
    in
        { model
            | zoom = zoom
            , canvasPosition =
                Position x y
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

        _ ->
            zoom
