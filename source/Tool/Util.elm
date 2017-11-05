module Tool.Util exposing (adjustPosition)

import Mouse exposing (Position)
import Types exposing (Model)


adjustPosition : Model -> Int -> Position -> Position
adjustPosition { canvasPosition, zoom } offset position =
    let
        x =
            List.sum
                [ position.x
                , -canvasPosition.x
                , -offset
                ]

        y =
            List.sum
                [ position.y
                , -canvasPosition.y
                , -offset
                ]
    in
    { x = x // zoom, y = y // zoom }
