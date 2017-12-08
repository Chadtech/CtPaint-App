module Tool.Util exposing (adjustPosition)

import Model exposing (Model)
import Mouse exposing (Position)
import Util exposing (tbw)


adjustPosition : Model -> Position -> Position
adjustPosition { canvasPosition, zoom } position =
    let
        x =
            List.sum
                [ position.x
                , -canvasPosition.x
                , -tbw
                ]

        y =
            List.sum
                [ position.y
                , -canvasPosition.y
                , -tbw
                ]
    in
    { x = x // zoom, y = y // zoom }
