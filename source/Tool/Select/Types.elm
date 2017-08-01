module Tool.Select.Types exposing (..)

--import Canvas exposing (Canvas)

import Mouse exposing (Position)
import Time exposing (Time)


--type ExternalMessage
--    = DrawSelection Position Canvas


type Message
    = OnScreenMouseDown Position
    | SubMouseMove Position
    | SubMouseUp Position
    | Tick Time
