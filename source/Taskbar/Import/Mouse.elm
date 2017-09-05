module Taskbar.Import.Mouse exposing (subscriptions)

import Mouse
import Taskbar.Import.Types exposing (Message(..), Model)


subscriptions : Sub Message
subscriptions =
    Sub.batch
        [ Mouse.moves HeaderMouseMove
        , Mouse.ups (always HeaderMouseUp)
        ]
