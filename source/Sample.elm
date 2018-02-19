module Sample exposing (handleScreenMouseUp)

import Color exposing (Color)
import Data.Color exposing (Swatches)
import Draw
import Helpers.Color as Color
import Helpers.Tool exposing (adjustPosition)
import Model exposing (Model)
import Mouse exposing (Position)


handleScreenMouseUp : Position -> Model -> Model
handleScreenMouseUp clientPos model =
    { model
        | color =
            Color.setSwatches
                (setTop clientPos model)
                model.color
    }


setTop : Position -> Model -> Swatches
setTop clientPos model =
    Color.setTop
        (getColorAt clientPos model)
        model.color.swatches


getColorAt : Position -> Model -> Color
getColorAt clientPos model =
    Draw.colorAt
        (adjustPosition model clientPos)
        model.canvas
