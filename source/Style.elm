module Style exposing (..)

import Data.Position exposing (Position)


toolbarWidth : Int
toolbarWidth =
    29


taskbarHeight : Int
taskbarHeight =
    29


palettebarHeight : Int
palettebarHeight =
    58


workareaOrigin : Position
workareaOrigin =
    { x = toolbarWidth
    , y = taskbarHeight
    }
