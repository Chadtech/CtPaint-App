module Data.Config exposing (Config)

import Data.Keys exposing (KeyCmd, KeyEvent)
import Dict exposing (Dict)


type alias Config =
    { quickKeys : Dict String String
    , keyCmds : Dict String KeyCmd
    , cmdKey : KeyEvent -> Bool
    }
