module Main.Model exposing (Model)

import Types.Session exposing (Session)
import Canvas exposing (Canvas, Size, DrawOp(..))
import Color exposing (Color)


type alias Model =
    { session : Maybe Session
    , canvas : Canvas
    , pendingDraw : DrawOp
    , palette : List Color
    , toolbarsSize : Size
    }
