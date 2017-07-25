module Draw.Util exposing (..)

import Mouse exposing (Position)
import Canvas exposing (Size)


makeRectParams : Position -> Position -> ( Position, Size )
makeRectParams p q =
    ( Position (min p.x q.x) (min p.y q.y)
    , Size (abs (p.x - q.x)) (abs (p.y - q.y))
    )
