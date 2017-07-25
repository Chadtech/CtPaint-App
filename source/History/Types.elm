module History.Types exposing (..)

import Canvas exposing (Canvas)
import Color exposing (Color)


type HistoryOp
    = CanvasChange Canvas
    | ColorChange Int Color
