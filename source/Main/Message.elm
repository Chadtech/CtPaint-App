module Main.Message exposing (Message(..))

import Toolbar.Horizontal.Types as HorizontalToolbar
import Window exposing (Size)
import Tool.Types exposing (Tool(..))
import Tool.Hand.Types as Hand
import Tool.Pencil.Types as Pencil
import Tool.ZoomIn.Types as ZoomIn
import Tool.ZoomOut.Types as ZoomOut
import Tool.Rectangle.Types as Rectangle
import Tool.RectangleFilled.Types as RectangleFilled
import ColorPicker.Types as ColorPicker
import Keyboard.Types as Keyboard
import Time exposing (Time)
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)


type Message
    = HorizontalToolbarMessage HorizontalToolbar.Message
    | GetWindowSize Size
    | SetTool Tool
    | KeyboardMessage Keyboard.Message
    | HandMessage Hand.Message
    | PencilMessage Pencil.Message
    | ZoomInMessage ZoomIn.Message
    | ZoomOutMessage ZoomOut.Message
    | RectangleMessage Rectangle.Message
    | RectangleFilledMessage RectangleFilled.Message
    | Tick Time
    | ColorPickerMessage ColorPicker.Message
    | ScreenMouseMove MouseEvent
    | ScreenMouseExit
