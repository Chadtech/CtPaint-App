module Tool.Util exposing (adjustPosition)

import Model exposing (Model)
import Mouse exposing (Position)


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
