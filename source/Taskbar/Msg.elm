module Taskbar.Msg exposing (Msg(..))

import Data.Keys as Key
import Data.Window exposing (Window)
import Taskbar.Data.Dropdown exposing (Dropdown)
import Tool.Data exposing (Tool)


type Msg
    = DropdownClickedOut
    | DropdownClicked Dropdown
    | HoveredOnto Dropdown
    | LoginClicked
    | UserClicked
    | LogoutClicked
    | AboutClicked
    | ReportBugClicked
    | KeyCmdClicked Key.Cmd
    | NewWindowClicked Window
    | UploadClicked
    | ToolClicked Tool
    | DrawingClicked
    | OpenImageLinkClicked
