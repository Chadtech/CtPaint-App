module ColorPicker.Handle exposing (handle)

import Main.Model exposing (Model)
import ColorPicker.Types as ColorPicker exposing (ExternalMessage(..))
import Array


handle : ( ColorPicker.Model, Maybe ExternalMessage ) -> Model -> Model
handle ( colorPicker, maybeMessage ) model =
    case maybeMessage of
        Nothing ->
            { model
                | colorPicker = colorPicker
            }

        Just (SetColor index color) ->
            { model
                | colorPicker = colorPicker
                , palette =
                    Array.set
                        index
                        color
                        model.palette
            }
