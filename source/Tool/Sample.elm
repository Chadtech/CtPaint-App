module Tool.Sample exposing (..)

import Draw.Util
import MouseEvents exposing (MouseEvent)
import Tool.Util exposing (adjustPosition)
import Types exposing (Model)
import Util exposing (tbw)


subMouseUp : MouseEvent -> Model -> Model
subMouseUp { clientPos } ({ swatches } as model) =
    let
        newSwatches =
            let
                colorAtPosition =
                    Draw.Util.colorAt
                        (adjustPosition model tbw clientPos)
                        model.canvas
            in
            { swatches
                | primary = colorAtPosition
            }
    in
    { model | swatches = newSwatches }
