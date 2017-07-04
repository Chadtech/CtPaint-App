module Main.Message exposing (Message(..))

import Toolbar.Horizontal.Types as HorizontalToolbar
import Window exposing (Size)


--import Toolbar.Vertical.Types as VerticalToolbar


type Message
    = HorizontalToolbarMessage HorizontalToolbar.Message
    | GetWindowSize Size



--| VeritcalToolbarMessage VerticalToolbar.Message
