module Reply
    exposing
        ( Reply(..)
        , nothing
        )

import Canvas exposing (Canvas)
import Color exposing (Color)
import Data.User exposing (User)


type Reply
    = NoReply
    | CloseMenu
    | IncorporateImageAsSelection Canvas
    | IncorporateImageAsCanvas Canvas
    | ScaleTo Int Int
    | AddText String
    | Replace Color Color
    | SetUser User
    | AttemptingLogin
    | SaveDrawingAttrs String
    | ResizeTo Int Int Int Int
    | Logout


nothing : model -> ( model, Cmd msg, Reply )
nothing model =
    ( model, Cmd.none, NoReply )
