module Tool.Zoom exposing (next, prev)


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
