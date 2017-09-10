module Menu.Download.Mouse exposing (subscriptions)

import Menu.Download.Types exposing (Message(..))
import Mouse


subscriptions : Sub Message
subscriptions =
    Sub.batch
        [ Mouse.moves HeaderMouseMove
        , Mouse.ups (always HeaderMouseUp)
        ]