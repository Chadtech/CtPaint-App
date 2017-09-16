module Menu.Download.Mouse exposing (subscriptions)

import Menu.Download.Types exposing (Msg(..))
import Mouse


subscriptions : Sub Msg
subscriptions =
    Sub.batch
        [ Mouse.moves HeaderMouseMove
        , Mouse.ups (always HeaderMouseUp)
        ]
