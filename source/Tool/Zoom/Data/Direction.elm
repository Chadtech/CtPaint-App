module Tool.Zoom.Data.Direction
    exposing
        ( Direction(..)
        , toInt
        )

-- TYPES --


type Direction
    = In
    | Out



-- HELPERS --


toInt : Direction -> Int
toInt direction =
    case direction of
        In ->
            -4

        Out ->
            1
