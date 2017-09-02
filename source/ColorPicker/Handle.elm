module ColorPicker.Handle exposing (handle)

import Main.Model exposing (Model)
import ColorPicker.Types as ColorPicker exposing (ExternalMessage(..))
import Array
import History.Update as History


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

        SetFocus focus ->
            { model
                | listenForKeyCmds = focus
            }

        UpdateHistory index color ->
            { model
                | colorPicker = colorPicker
            }
                |> History.addColor index color
