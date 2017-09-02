module Taskbar.Types exposing (..)

import Taskbar.Download.Types as Download


type Message
    = DropDown (Maybe Option)
    | HoverOnto Option
    | InitDownload
    | DownloadMessage Download.Message
    | NoOp


type Option
    = File
    | Edit
    | Transform
    | View
    | Help
