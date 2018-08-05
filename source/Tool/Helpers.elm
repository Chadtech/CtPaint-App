module Tool.Helpers
    exposing
        ( getColor
        )

import Color exposing (Color)
import Color.Swatches.Data exposing (Swatches)
import Mouse.Extra


getColor : Mouse.Extra.Button -> Swatches -> Color
getColor button swatches =
    case button of
        Mouse.Extra.Left ->
            swatches.top

        Mouse.Extra.Right ->
            swatches.bottom
