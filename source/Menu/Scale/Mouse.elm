module Menu.Scale.Mouse exposing (subscriptions)

import Menu.Scale.Types exposing (Message(..))
import Mouse


subscriptions : Sub Message
subscriptions =
    Sub.batch
        [ Mouse.moves HeaderMouseMove
        , Mouse.ups (always HeaderMouseUp)
        ]
