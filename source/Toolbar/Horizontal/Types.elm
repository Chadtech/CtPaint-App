module Toolbar.Horizontal.Types exposing (..)

import Types.Mouse exposing (Direction(..))
import Color exposing (Color)


type Message
    = ResizeToolbar Direction
    | PaletteSquareClick Color Int
