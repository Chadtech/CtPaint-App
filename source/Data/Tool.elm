module Data.Tool exposing (Tool(..), init)

import Mouse exposing (Position)
import Mouse.Extra exposing (Button)


init : Tool
init =
    Pencil Nothing


type Tool
    = Hand (Maybe ( Position, Position ))
    | Sample
    | Fill
    | Select (Maybe Position)
    | ZoomIn
    | ZoomOut
    | Pencil (Maybe ( Position, Button ))
    | Line (Maybe ( Position, Button ))
    | Rectangle (Maybe ( Position, Button ))
    | RectangleFilled (Maybe ( Position, Button ))
    | Eraser (Maybe ( Position, Button ))
