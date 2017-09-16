module Tool.Sample.Update exposing (update)

import Draw.Util exposing (colorAt)
import Model exposing (Model)
import Tool.Sample.Types exposing (Msg(..))
import Tool.Util exposing (adjustPosition)
import Util exposing (tbw)


update : Msg -> Model -> Model
update message ({ swatches } as model) =
    case message of
        SubMouseUp position ->
            let
                newSwatches =
                    let
                        colorAtPosition =
                            colorAt
                                (adjustPosition model tbw position)
                                model.canvas
                    in
                    { swatches
                        | primary = colorAtPosition
                    }
            in
            { model
                | swatches =
                    newSwatches
            }
