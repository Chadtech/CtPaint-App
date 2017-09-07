module Taskbar.Types exposing (..)

import Keyboard.Types exposing (Command(..))
import Taskbar.Download.Types as Download
import Taskbar.Import.Types as Import


type Message
    = DropDown (Maybe Option)
    | HoverOnto Option
    | InitDownload
    | InitImport
    | DownloadMessage Download.Message
    | ImportMessage Import.Message
    | SwitchMinimap Bool
    | Command Command
    | NoOp


type Option
    = File
    | Edit
    | Transform
    | View
    | Help