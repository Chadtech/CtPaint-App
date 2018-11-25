module Canvas.Helpers exposing
    ( blank
    , defaultSize
    , encode
    , noop
    , tiny
    )

import Canvas exposing (Canvas, DrawOp(..))
import Canvas.Data.BackgroundColor as BackgroundColor
    exposing
        ( BackgroundColor(Black, White)
        )
import Data.Size as Size exposing (Size)
import Json.Encode as JE exposing (Value)


blank : Canvas
blank =
    defaultSize
        |> Canvas.initialize
        |> BackgroundColor.fill White


{-| I use this super small canvas to make it easy to hide,
which I do when the app is initialized, but the user hasnt
set any parameters on their project (width, height, background
color)
-}
tiny : Canvas
tiny =
    { width = 1, height = 1 }
        |> Canvas.initialize
        |> BackgroundColor.fill Black


defaultSize : Size
defaultSize =
    { width = 400
    , height = 400
    }


noop : DrawOp
noop =
    Canvas.batch []


encode : Canvas -> Value
encode =
    Canvas.toDataUrl "image/png" 1 >> JE.string
