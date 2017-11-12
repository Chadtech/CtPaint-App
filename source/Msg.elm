module Msg exposing (Msg(..))

import Color exposing (Color)
import ColorPicker
import Data.Taskbar as Taskbar
import Menu
import Minimap
import MouseEvents exposing (MouseEvent)
import Taskbar
import Time exposing (Time)
import Tool exposing (Tool)
import Toolbar
import Types exposing (KeyEvent, NewWindow(..), Op(..))
import Window exposing (Size)


type Msg
    = WindowSizeReceived Size
    | ToolbarMsg Toolbar.Msg
    | TaskbarMsg Taskbar.Msg
    | ToolMsg Tool.Msg
    | MenuMsg Menu.Msg
    | Tick Time
    | ColorPickerMsg ColorPicker.Msg
    | MinimapMsg Minimap.Msg
    | ScreenMouseMove MouseEvent
    | ScreenMouseExit
    | KeyboardEvent (Result String KeyEvent)
    | PaletteSquareClick Color
    | OpenColorPicker Color Int
    | AddPaletteSquare
