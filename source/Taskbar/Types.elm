module Taskbar.Types exposing (..)

import Keyboard.Types exposing (Command(..))


type Message
    = DropDown (Maybe Option)
    | HoverOnto Option
    | SwitchMinimap Bool
    | Command Command
    | NoOp


type Option
    = File
    | Edit
    | Transform
    | Tools
    | View
    | Help
