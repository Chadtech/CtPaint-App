module Taskbar.Types exposing (..)


type Message
    = DropDown (Maybe Option)
    | HoverOnto Option
    | InitDownload
    | NoOp


type Option
    = File
    | Edit
    | Transform
    | View
    | Help
