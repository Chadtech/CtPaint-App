module Tool.Util exposing (adjustPosition)

import Mouse exposing (Position)
import Types exposing (Model)


adjustPosition : Model -> Int -> Position -> Position
adjustPosition { canvas, canvasPosition, zoom } offset { x, y } =
    let
        x_ =
            List.sum
                [ x
                , -canvasPosition.x
                , -offset
                ]

        y_ =
            List.sum
                [ y
                , -canvasPosition.y
                , -offset
                ]
    in
    Position (x_ // zoom) (y_ // zoom)
