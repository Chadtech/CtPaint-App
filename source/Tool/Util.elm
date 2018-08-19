module Tool.Util
    exposing
        ( getColor
        )

import Color exposing (Color)
import Color.Swatches.Data exposing (Swatches)
import Html.Mouse


getColor : Html.Mouse.Button -> Swatches -> Color
getColor button swatches =
    case button of
        Html.Mouse.Left ->
            swatches.top

        Html.Mouse.Right ->
            swatches.bottom
