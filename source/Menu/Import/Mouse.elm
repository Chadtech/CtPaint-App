module Menu.Import.Mouse exposing (subscriptions)

import Menu.Import.Types exposing (Model, Msg(..))
import Mouse


subscriptions : Sub Msg
subscriptions =
    Sub.batch
        [ Mouse.moves HeaderMouseMove
        , Mouse.ups (always HeaderMouseUp)
        ]
