module Main.Message exposing (Message(..))

import Palette.Types as Palette
import Window exposing (Size)
import Tool.Types exposing (Tool(..))
import Tool.Hand.Types as Hand
import Tool.Pencil.Types as Pencil
import Tool.Line.Types as Line
import Tool.ZoomIn.Types as ZoomIn
import Tool.ZoomOut.Types as ZoomOut
import Tool.Rectangle.Types as Rectangle
import Tool.RectangleFilled.Types as RectangleFilled
import Tool.Select.Types as Select
import Tool.Sample.Types as Sample
import Tool.Fill.Types as Fill
import ColorPicker.Types as ColorPicker
import Minimap.Types as Minimap
import Taskbar.Types as Taskbar
import Keyboard.Types as Keyboard
import Time exposing (Time)
import MouseEvents exposing (MouseEvent)


type Message
    = PaletteMessage Palette.Message
    | GetWindowSize Size
    | SetTool Tool
    | KeyboardMessage Keyboard.Message
    | HandMessage Hand.Message
    | PencilMessage Pencil.Message
    | LineMessage Line.Message
    | ZoomInMessage ZoomIn.Message
    | ZoomOutMessage ZoomOut.Message
    | RectangleMessage Rectangle.Message
    | RectangleFilledMessage RectangleFilled.Message
    | SelectMessage Select.Message
    | SampleMessage Sample.Message
    | FillMessage Fill.Message
    | TaskbarMessage Taskbar.Message
    | Tick Time
    | ColorPickerMessage ColorPicker.Message
    | MinimapMessage Minimap.Message
    | ScreenMouseMove MouseEvent
    | ScreenMouseExit
