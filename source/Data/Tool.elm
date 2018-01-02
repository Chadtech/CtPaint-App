module Data.Tool exposing (Tool(..), init)

import Mouse exposing (Position)


init : Tool
init =
    Hand Nothing


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
