module Reply
    exposing
        ( Reply(..)
        , withModel
        , withNoReply
        , withReply
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


withReply : reply -> model -> ( model, Maybe reply )
withReply reply model =
    ( model, Just reply )


withModel : model -> reply -> ( model, Maybe reply )
withModel model reply =
    ( model, Just reply )


withNoReply : model -> ( model, Maybe reply )
withNoReply model =
    ( model, Nothing )
