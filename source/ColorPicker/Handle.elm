module ColorPicker.Handle exposing (handle)

import Array
import ColorPicker.Types as ColorPicker exposing (ExternalMessage(..))
import History.Update as History
import Main.Model exposing (Model)


handle : ( ColorPicker.Model, ExternalMessage ) -> Model -> Model
handle ( colorPicker, maybeMessage ) model =
    case maybeMessage of
        DoNothing ->
            { model
                | colorPicker = colorPicker
            }

        SetColor index color ->
            { model
                | colorPicker = colorPicker
                , palette =
                    Array.set
                        index
                        color
                        model.palette
            }

        UpdateHistory index color ->
            { model
                | colorPicker = colorPicker
            }
                |> History.addColor index color
