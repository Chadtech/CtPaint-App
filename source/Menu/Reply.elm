module Menu.Reply
    exposing
        ( Reply(..)
        )

import Canvas exposing (Canvas, Size)
import Color exposing (Color)
import Data.Drawing exposing (Drawing)
import Data.User exposing (User)
import Mouse exposing (Position)


type Reply
    = CloseMenu
    | IncorporateImageAsSelection Canvas
    | IncorporateImageAsCanvas Canvas
    | ScaleTo Int Int
    | AddText String
    | Replace Color Color
    | SetUser User
    | AttemptingLogin
    | NoLongerLoggingIn
    | SaveDrawingAttrs String
    | ResizeTo Position Size
    | StartNewDrawing String Bool Canvas
    | IncorporateDrawing Drawing
    | TrySaving
    | Logout
