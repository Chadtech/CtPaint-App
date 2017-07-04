module Main.Model exposing (Model)

import Types.Session exposing (Session)
import Canvas exposing (Canvas, Size, DrawOp(..))
import Color exposing (Color)
import Main.Message exposing (Message(..))
import Mouse exposing (Position)


type alias Model =
    { session : Maybe Session
    , canvas : Canvas
    , pendingDraw : DrawOp
    , palette : List Color
    , horizontalToolbarHeight : Int
    , subMouseMove : Maybe (Position -> Message)
    , windowHeight : Int
    }
