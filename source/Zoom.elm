module Zoom
    exposing
        ( set
        , zoomInScreenMouseUp
        , zoomOutScreenMouseUp
        )

import Canvas exposing (Size)
import Helpers.Zoom as Zoom
import Model exposing (Model)
import Mouse exposing (Position)
import Util exposing (tbw)


-- MOUSE EVENTS --


zoomInScreenMouseUp : Position -> Model -> Model
zoomInScreenMouseUp clientPos model =
    let
        newZoom =
            Zoom.next model.zoom
    in
    if model.zoom == newZoom then
        model
    else
        adjust clientPos -1 (set newZoom model)


zoomOutScreenMouseUp : Position -> Model -> Model
zoomOutScreenMouseUp clientPos model =
    let
        newZoom =
            Zoom.prev model.zoom
    in
    if model.zoom == newZoom then
        model
    else
        adjust clientPos 1 (set newZoom model)



-- HELPERS --


adjust : Position -> Int -> Model -> Model
adjust { x, y } bias ({ zoom, windowSize, canvasPosition } as model) =
    let
        halfWindowSize =
            { width = (windowSize.width - tbw) // 2
            , height = (windowSize.height - tbw) // 2
            }

        x_ =
            (x - halfWindowSize.width) // zoom

        y_ =
            (y - halfWindowSize.height) // zoom
    in
    { model
        | canvasPosition =
            { x = canvasPosition.x + (x_ * bias)
            , y = canvasPosition.y + (y_ * bias)
            }
    }


set : Int -> Model -> Model
set zoom ({ canvasPosition, windowSize } as model) =
    let
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
