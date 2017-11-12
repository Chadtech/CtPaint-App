module Msg exposing (Msg(..))

import Color exposing (Color)
import ColorPicker
import Data.Keys exposing (KeyEvent)
import Menu
import Minimap
import MouseEvents exposing (MouseEvent)
import Palette
import Taskbar
import Time exposing (Time)
import Tool exposing (Tool)
import Toolbar
import Window exposing (Size)


type Msg
    = WindowSizeReceived Size
    | ToolbarMsg Toolbar.Msg
    | TaskbarMsg Taskbar.Msg
    | PaletteMsg Palette.Msg
    | ToolMsg Tool.Msg
    | MenuMsg Menu.Msg
    | Tick Time
    | ColorPickerMsg ColorPicker.Msg
    | MinimapMsg Minimap.Msg
    | ScreenMouseMove MouseEvent
    | ScreenMouseExit
    | KeyboardEvent (Result String KeyEvent)
