module Draw.Util exposing (..)

import Mouse exposing (Position)
import Canvas exposing (Size, Point, Canvas)
import Util exposing (positionMin, toPoint)
import Color exposing (Color)
import Array exposing (Array)
import List.Extra exposing (groupsOf)


makeRectParams : Position -> Position -> ( Position, Size )
makeRectParams p q =
    ( positionMin p q
    , Size (abs (p.x - q.x)) (abs (p.y - q.y))
    )


colorAt : Position -> Canvas -> Color
colorAt pos =
    Canvas.getImageData (toPoint pos) (Size 1 1)
        >> toColor


toColor : List Int -> Color
toColor values =
    case values of
        r :: g :: b :: a :: [] ->
            Color.rgb r g b

        _ ->
            Color.black


toGrid : Canvas -> Array (Array Color)
toGrid canvas =
    let
        size =
            Canvas.getSize canvas
    in
        canvas
            |> Canvas.getImageData (Point 0 0) size
            |> groupsOf 4
            |> List.map toColor
            |> groupsOf size.width
            |> List.map Array.fromList
            |> Array.fromList
