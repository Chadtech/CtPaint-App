module Main.Model exposing (Model)

import Types.Session as Session exposing (Session)
import Tool.Types exposing (Tool(..))
import ColorPicker.Types as ColorPicker
import Canvas exposing (Canvas, Size, DrawOp(..))
import Color exposing (Color)
import Main.Message exposing (Message(..))
import Mouse exposing (Position)
import Palette.Types exposing (Swatches)
import Array exposing (Array)


type alias Model =
    { session : Maybe Session
    , canvas : Canvas
    , canvasPosition : Position
    , pendingDraw : DrawOp
    , swatches : Swatches
    , palette : Array Color
    , horizontalToolbarHeight : Int
    , subMouseMove : Maybe (Position -> Message)
    , windowSize : Size
    , tool : Tool
    , zoom : Int
    , colorPicker : ColorPicker.Model
    , ctrlDown : Bool
    , textInputFocused : Bool
    }
