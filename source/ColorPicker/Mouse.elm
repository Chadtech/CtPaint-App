module ColorPicker.Mouse exposing (subscriptions)

import ColorPicker.Types as ColorPicker exposing (Model)
import Main.Message exposing (Message(..))
import Mouse


subscriptions : Model -> Sub Message
subscriptions model =
    if model.show && (model.clickState /= Nothing) then
        Sub.batch
            [ Mouse.moves
                (ColorPickerMessage << ColorPicker.HeaderMouseMove)
            , Mouse.ups
                (ColorPickerMessage << ColorPicker.HeaderMouseUp)
            ]
    else
        Sub.none
