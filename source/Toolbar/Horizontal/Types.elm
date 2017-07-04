module Toolbar.Horizontal.Types exposing (..)

import Mouse exposing (..)


type Message
    = ResizeToolbar MouseDirection


type MouseDirection
    = Up Position
    | Down Position
    | Move Position
