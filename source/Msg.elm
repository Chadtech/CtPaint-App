module Msg exposing (Msg(..))

import ColorPicker.Types as ColorPicker
import Keyboard.Types as Keyboard
import Menu.Types as Menu
import Minimap.Types as Minimap
import MouseEvents exposing (MouseEvent)
import Palette.Types as Palette
import Taskbar.Types as Taskbar
import Time exposing (Time)
import Tool.Fill.Types as Fill
import Tool.Hand.Types as Hand
import Tool.Line.Types as Line
import Tool.Pencil.Types as Pencil
import Tool.Rectangle.Types as Rectangle
import Tool.RectangleFilled.Types as RectangleFilled
import Tool.Sample.Types as Sample
import Tool.Select.Types as Select
import Tool.Types exposing (Tool(..))
import Tool.ZoomIn.Types as ZoomIn
import Tool.ZoomOut.Types as ZoomOut
import Window exposing (Size)


type Msg
    = PaletteMsg Palette.Msg
    | GetWindowSize Size
    | SetTool Tool
    | KeyboardMsg Keyboard.Msg
    | HandMsg Hand.Msg
    | PencilMsg Pencil.Msg
    | LineMsg Line.Msg
    | ZoomInMsg ZoomIn.Msg
    | ZoomOutMsg ZoomOut.Msg
    | RectangleMsg Rectangle.Msg
    | RectangleFilledMsg RectangleFilled.Msg
    | SelectMsg Select.Msg
    | SampleMsg Sample.Msg
    | FillMsg Fill.Msg
    | TaskbarMsg Taskbar.Msg
    | MenuMsg Menu.Msg
    | Tick Time
    | ColorPickerMsg ColorPicker.Msg
    | MinimapMsg Minimap.Msg
    | ScreenMouseMove MouseEvent
    | ScreenMouseExit
    | HandleWindowFocus Bool
