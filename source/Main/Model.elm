module Main.Model exposing (Model)

import Types.Session as Session exposing (Session)
import Tool.Types exposing (Tool(..))
import Canvas exposing (Canvas, Size, DrawOp(..))
import Color exposing (Color)
import Main.Message exposing (Message(..))
import Mouse exposing (Position)
import Palette.Types exposing (Swatches)


type alias Model =
    { session : Maybe Session
    , canvas : Canvas
    , canvasPosition : Position
    , pendingDraw : DrawOp
    , swatches : Swatches
    , palette : List Color
    , horizontalToolbarHeight : Int
    , subMouseMove : Maybe (Position -> Message)
    , windowSize : Size
    , tool : Tool
    }
