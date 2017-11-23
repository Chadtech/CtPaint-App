module Reply exposing (Reply(..))

import Canvas exposing (Canvas)
import Color exposing (Color)
import Data.Project exposing (Project)
import Data.User exposing (User)


type Reply
    = NoReply
    | CloseMenu
    | IncorporateImage Canvas
    | ScaleTo Int Int
    | AddText String
    | Replace Color Color
    | SetUser User
    | SetToNoSession
    | SetProject String Project
