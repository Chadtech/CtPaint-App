module ColorPicker.Mouse exposing (subscriptions)

import ColorPicker.Types exposing (Model, Msg(..))
import Mouse


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.show && model.clickState /= Nothing then
        Sub.batch
            [ Mouse.moves HeaderMouseMove
            , Mouse.ups HeaderMouseUp
            ]
    else
        Sub.none
