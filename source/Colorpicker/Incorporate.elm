module ColorPicker.Incorporate exposing (incorporate)

import Array
import ColorPicker.Types as ColorPicker exposing (ExternalMsg(..))
import History.Update as History
import Menu.Ports
import Types exposing (Model)


incorporate : ( ColorPicker.Model, ExternalMsg ) -> Model -> ( Model, Cmd message )
incorporate ( colorPicker, maybeMsg ) model =
    case maybeMsg of
        DoNothing ->
            { model
                | colorPicker = colorPicker
            }
                ! []

        SetColor index color ->
            { model
                | colorPicker = colorPicker
                , palette =
                    Array.set
                        index
                        color
                        model.palette
            }
                ! []

        UpdateHistory index color ->
            let
                newModel =
                    { model
                        | colorPicker = colorPicker
                    }
                        |> History.addColor index color
            in
            newModel ! []

        StealFocus ->
            ( model, Menu.Ports.stealFocus () )

        ReturnFocus ->
            ( model, Menu.Ports.returnFocus () )
