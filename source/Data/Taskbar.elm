module Data.Taskbar
    exposing
        ( Dropdown(..)
        , toString
        )

import String


-- TYPES --


type Dropdown
    = File
    | Edit
    | Transform
    | Tools
    | Colors
    | View
    | Help
    | User



-- HELPERS --


toString : Dropdown -> String
toString =
    Basics.toString >> String.toLower
