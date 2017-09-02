module Taskbar.Download.Mouse exposing (subscriptions)

import Taskbar.Download.Types exposing (Model, Message(..))
import Mouse


subscriptions : Sub Message
subscriptions =
    Sub.batch
        [ Mouse.moves HeaderMouseMove
        , Mouse.ups (always HeaderMouseUp)
        ]
