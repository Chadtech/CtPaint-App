module Data.Position
    exposing
        ( Position
        , add
        , divideBy
        , fromPoint
        , max
        , min
        , multiplyBy
        , relativeToTarget
        , subtract
        , subtractFrom
        , subtractFromX
        , subtractFromY
        , toPoint
        )

import Canvas exposing (Point)
import MouseEvents exposing (MouseEvent)


-- TYPES --


type alias Position =
    { x : Int
    , y : Int
    }



-- HELPERS --


relativeToTarget : MouseEvent -> Position
relativeToTarget { clientPos, targetPos } =
    { x = clientPos.x - targetPos.x
    , y = clientPos.y - targetPos.y
    }


min : Position -> Position -> Position
min p q =
    { x = Basics.min p.x q.x, y = Basics.min p.y q.y }


max : Position -> Position -> Position
max p q =
    { x = Basics.max p.x q.x, y = Basics.max p.y q.y }


fromPoint : Point -> Position
fromPoint { x, y } =
    { x = floor x, y = floor y }


toPoint : Position -> Point
toPoint { x, y } =
    { x = toFloat x, y = toFloat y }


add : Position -> Position -> Position
add p q =
    { x = p.x + q.x, y = p.y + q.y }


subtract : Position -> Position -> Position
subtract p q =
    { x = q.x - p.x, y = q.y - p.y }


subtractFrom : Position -> Position -> Position
subtractFrom p q =
    subtract q p


subtractFromX : Int -> Position -> Position
subtractFromX int p =
    { p | x = p.x - int }


subtractFromY : Int -> Position -> Position
subtractFromY int p =
    { p | y = p.y - int }


divideBy : Int -> Position -> Position
divideBy int { x, y } =
    { x = x // int, y = y // int }


multiplyBy : Int -> Position -> Position
multiplyBy int { x, y } =
    { x = x * int, y = y * int }
