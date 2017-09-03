module Taskbar.Import.Mouse exposing (subscriptions)

import Taskbar.Import.Types exposing (Model, Message(..))
import Mouse


subscriptions : Sub Message
subscriptions =
    Sub.batch
        [ Mouse.moves HeaderMouseMove
        , Mouse.ups (always HeaderMouseUp)
        ]
