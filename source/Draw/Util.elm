module Draw.Util exposing (..)

import Mouse exposing (Position)
import Canvas exposing (Size, Point, Canvas)
import Util exposing (positionMin, toPoint)
import Color exposing (Color)


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
