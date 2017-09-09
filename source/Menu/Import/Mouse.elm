module Menu.Import.Mouse exposing (subscriptions)

import Menu.Import.Types exposing (Message(..), Model)
import Mouse


subscriptions : Sub Message
subscriptions =
    Sub.batch
        [ Mouse.moves HeaderMouseMove
        , Mouse.ups (always HeaderMouseUp)
        ]
