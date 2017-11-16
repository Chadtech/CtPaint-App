module Data.Tool exposing (Tool(..))

import Mouse exposing (Position)


type Tool
    = Hand (Maybe ( Position, Position ))
    | Sample
    | Fill
    | Select (Maybe Position)
    | ZoomIn
    | ZoomOut
    | Pencil (Maybe Position)
    | Line (Maybe Position)
    | Rectangle (Maybe Position)
    | RectangleFilled (Maybe Position)
