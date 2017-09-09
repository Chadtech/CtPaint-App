module Main.Message exposing (Message(..))

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
    | MenuMessage Menu.Message
    | Tick Time
    | ColorPickerMessage ColorPicker.Message
    | MinimapMessage Minimap.Message
    | ScreenMouseMove MouseEvent
    | ScreenMouseExit
    | HandleWindowFocus Bool
