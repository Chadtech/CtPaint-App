module Main.Message exposing (Message(..))

import Toolbar.Horizontal.Types as HorizontalToolbar
import Window exposing (Size)
import Tool.Types exposing (Tool(..))
import Types.Mouse exposing (Direction)
import Tool.Hand.Types as Hand


--import Toolbar.Vertical.Types as VerticalToolbar


type Message
    = HorizontalToolbarMessage HorizontalToolbar.Message
    | GetWindowSize Size
    | SetTool Tool
    | HandMessage Hand.Message



--| VeritcalToolbarMessage VerticalToolbar.Message
