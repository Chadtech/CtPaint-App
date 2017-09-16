module Menu.Scale.Mouse exposing (subscriptions)

import Menu.Scale.Types exposing (Msg(..))
import Mouse


subscriptions : Sub Msg
subscriptions =
    Sub.batch
        [ Mouse.moves HeaderMouseMove
        , Mouse.ups (always HeaderMouseUp)
        ]
