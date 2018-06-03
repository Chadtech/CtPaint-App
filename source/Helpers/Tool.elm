module Helpers.Tool
    exposing
        ( adjustPosition
        , getColor
        )

import Color exposing (Color)
import Data.Color exposing (Swatches)
import Model exposing (Model)
import Mouse exposing (Position)
import Mouse.Extra
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


getColor : Mouse.Extra.Button -> Swatches -> Color
getColor button swatches =
    case button of
        Mouse.Extra.Left ->
            swatches.top

        Mouse.Extra.Right ->
            swatches.bottom
