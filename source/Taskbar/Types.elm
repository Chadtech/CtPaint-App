module Taskbar.Types exposing (..)

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
    | NoOp


type Option
    = File
    | Edit
    | Transform
    | View
    | Help
