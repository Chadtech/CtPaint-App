module Toolbar.Top.Types exposing (..)


type Message
    = Download
    | Open


type alias Model =
    { fileIsOpen : Bool
    , editIsOpen : Bool
    }


init : Model
init =
    { fileIsOpen = False
    , editIsOpen = False
    }
