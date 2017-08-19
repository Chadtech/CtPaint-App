module Tool.Sample.Update exposing (update)

import Main.Model exposing (Model)
import Tool.Sample.Types exposing (Message(..))
import Tool.Util exposing (adjustPosition)
import Util exposing (tbw)
import Draw.Util exposing (colorAt)


update : Message -> Model -> Model
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
