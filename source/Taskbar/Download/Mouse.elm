module Taskbar.Download.Mouse exposing (subscriptions)

import Mouse
import Taskbar.Download.Types exposing (Message(..), Model)


subscriptions : Sub Message
subscriptions =
    Sub.batch
        [ Mouse.moves HeaderMouseMove
        , Mouse.ups (always HeaderMouseUp)
        ]
