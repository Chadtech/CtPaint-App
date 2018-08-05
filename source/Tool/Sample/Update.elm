module Tool.Sample.Update
    exposing
        ( update
        )

import Color exposing (Color)
import Color.Model
import Color.Swatches.Data as Swatches
    exposing
        ( Swatches
        )
import Data.Position exposing (Position)
import Draw
import Model exposing (Model)
import Tool.Msg exposing (Msg(..))


update : Msg -> Model -> Model
update msg model =
    case msg of
        WorkareaMouseUp positionOnCanvas ->
            { model
                | color =
                    Color.Model.setSwatches
                        (setTopSwatch positionOnCanvas model)
                        model.color
            }

        _ ->
            model


setTopSwatch : Position -> Model -> Swatches
setTopSwatch positionOnCanvas model =
    Swatches.setTop
        (Draw.colorAt positionOnCanvas model.canvas.main)
        model.color.swatches
