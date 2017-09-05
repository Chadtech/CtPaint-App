module Tool.Util exposing (adjustPosition)

import Main.Model exposing (Model)
import Mouse exposing (Position)


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
