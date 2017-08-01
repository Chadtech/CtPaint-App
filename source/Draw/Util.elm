module Draw.Util exposing (..)

import Mouse exposing (Position)
import Canvas exposing (Size)
import Util exposing (positionMin)


makeRectParams : Position -> Position -> ( Position, Size )
makeRectParams p q =
    ( positionMin p q
    , Size (abs (p.x - q.x)) (abs (p.y - q.y))
    )
