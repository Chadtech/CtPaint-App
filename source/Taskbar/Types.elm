module Taskbar.Types exposing (..)

import Keyboard.Types exposing (Command(..))
import Menu.Download.Types as Download
import Menu.Import.Types as Import
import Menu.Scale.Types as Scale


type Message
    = DropDown (Maybe Option)
    | HoverOnto Option
    | DownloadMessage Download.Message
    | ImportMessage Import.Message
    | ScaleMessage Scale.Message
    | SwitchMinimap Bool
    | Command Command
    | NoOp


type Option
    = File
    | Edit
    | Transform
    | View
    | Help
