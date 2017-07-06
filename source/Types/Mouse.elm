module Types.Mouse exposing (Direction(..))

import Mouse exposing (Position)


type Direction
    = Up Position
    | Down Position
    | Move Position
