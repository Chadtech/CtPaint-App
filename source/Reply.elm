module Reply
    exposing
        ( Reply(..)
        , fromModel
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
    | NoLongerLoggingIn
    | SaveDrawingAttrs String
    | ResizeTo Int Int Int Int
    | StartNewDrawing String Bool Canvas
    | Logout


nothing : model -> ( model, Cmd msg, Reply )
nothing model =
    ( model, Cmd.none, NoReply )


fromModel : Cmd msg -> Reply -> model -> ( model, Cmd msg, Reply )
fromModel cmd reply model =
    ( model, cmd, reply )
