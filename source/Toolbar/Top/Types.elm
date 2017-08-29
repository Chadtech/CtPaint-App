module Toolbar.Top.Types exposing (..)


type Message
    = DropDown (Maybe Option)


type Option
    = File
    | Edit
    | Transform
