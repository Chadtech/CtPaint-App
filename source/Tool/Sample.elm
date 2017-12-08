module Tool.Sample exposing (..)

import Draw
import Model exposing (Model)
import MouseEvents exposing (MouseEvent)
import Tool.Util exposing (adjustPosition)


subMouseUp : MouseEvent -> Model -> Model
subMouseUp { clientPos } ({ swatches } as model) =
    { model
        | swatches =
            { swatches
                | primary =
                    Draw.colorAt
                        (adjustPosition model clientPos)
                        model.canvas
            }
    }
