module Color.Picker.Subscriptions
    exposing
        ( subscriptions
        )

import Color.Picker.Data exposing (Picker)
import Color.Picker.Msg exposing (Msg(..))
import Mouse


subscriptions : Picker -> Sub Msg
subscriptions picker =
    if picker.show then
        [ Mouse.moves ClientMouseMove
        , Mouse.ups (always ClientMouseUp)
        ]
            |> Sub.batch
    else
        Sub.none
