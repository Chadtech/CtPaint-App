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
                (setPrimary clientPos model)
                model.color
    }


setPrimary : Position -> Model -> Swatches
setPrimary clientPos model =
    Color.setPrimary (getColorAt clientPos model) model.color.swatches


getColorAt : Position -> Model -> Color
getColorAt clientPos model =
    Draw.colorAt
        (adjustPosition model clientPos)
        model.canvas