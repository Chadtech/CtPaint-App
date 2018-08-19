module Taskbar.Data.Dropdown
    exposing
        ( Dropdown(..)
        , toString
        )

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
