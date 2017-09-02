module Toolbar.Top.Types exposing (..)


type Message
    = DropDown (Maybe Option)
    | HoverOnto Option
    | Download
    | NoOp


type Option
    = File
    | Edit
    | Transform
    | View
    | Help
