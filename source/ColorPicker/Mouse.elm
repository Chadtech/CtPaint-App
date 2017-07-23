module ColorPicker.Mouse exposing (subscriptions)

import ColorPicker.Types as ColorPicker exposing (Model)
import Main.Message exposing (Message(..))
import Mouse


subscriptions : Model -> Sub Message
subscriptions model =
    if model.show && (model.clickState /= Nothing) then
        Sub.batch
            [ ColorPicker.HeaderMouseMove
                >> ColorPickerMessage
                |> Mouse.moves
            , ColorPicker.HeaderMouseUp
                >> ColorPickerMessage
                |> Mouse.ups
            ]
    else
        Sub.none
