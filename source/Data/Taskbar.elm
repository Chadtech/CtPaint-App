module Data.Taskbar
    exposing
        ( Dropdown(..)
        , toString
        )

import String


type Dropdown
    = File
    | Edit
    | Transform
    | Tools
    | Colors
    | View
    | Help
    | User


toString : Dropdown -> String
toString =
    Basics.toString >> String.toLower
