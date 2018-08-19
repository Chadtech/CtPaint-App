module Minimap.Msg
    exposing
        ( Msg(..)
        )

import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)


type Msg
    = XButtonMouseDown
    | XButtonMouseUp
    | ZoomInClicked
    | ZoomOutClicked
    | CenterClicked
    | HeaderMouseDown MouseEvent
    | MinimapPortalMouseDown MouseEvent
    | MouseMoved Position
    | MouseUp
