module Reply
    exposing
        ( Reply(..)
        , fromModel
        , nothing
        )

import Canvas exposing (Canvas, Size)
import Color exposing (Color)
import Data.Drawing exposing (Drawing)
import Data.User exposing (User)
import Mouse exposing (Position)


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
    | NoLongerLoggingIn
    | SaveDrawingAttrs String
    | ResizeTo Position Size
    | StartNewDrawing String Bool Canvas
    | IncorporateDrawing Drawing
    | TrySaving
    | Logout


nothing : model -> ( model, Cmd msg, Reply )
nothing model =
    ( model, Cmd.none, NoReply )


fromModel : Cmd msg -> Reply -> model -> ( model, Cmd msg, Reply )
fromModel cmd reply model =
    ( model, cmd, reply )
