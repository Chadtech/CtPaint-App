module Main.Message exposing (Message(..))

import Toolbar.Horizontal.Types as HorizontalToolbar
import Window exposing (Size)
import Tool.Types exposing (Tool(..))
import Tool.Hand.Types as Hand
import Tool.Pencil.Types as Pencil
import Time exposing (Time)


type Message
    = HorizontalToolbarMessage HorizontalToolbar.Message
    | GetWindowSize Size
    | SetTool Tool
    | HandMessage Hand.Message
    | PencilMessage Pencil.Message
    | Tick Time
