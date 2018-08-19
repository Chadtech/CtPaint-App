module Helpers.Keys exposing (getKeysLabel)

import Data.Config exposing (Config)
import Data.Keys as Key exposing (Cmd(NoCmd))
import Dict


getKeysLabel : Config -> Key.Cmd -> String
getKeysLabel { cmdKey, quickKeys } cmd =
    quickKeys
        |> Dict.get (toString cmd)
        |> Maybe.withDefault ""
        |> String.toLower
