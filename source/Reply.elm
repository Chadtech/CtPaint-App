module Reply exposing (Reply(..))

import Canvas exposing (Canvas)
import Color exposing (Color)


type Reply
    = NoReply
    | CloseMenu
    | IncorporateImage Canvas
    | ScaleTo Int Int
    | AddText String
    | Replace Color Color
