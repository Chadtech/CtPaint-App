module Helpers.Keys exposing (getCmd, getKeysLabel)

import Data.Config exposing (Config)
import Data.Keys exposing (KeyCmd(NoCmd), KeyEvent)
import Dict


-- keyCmd from Event --


getCmd : Config -> KeyEvent -> KeyCmd
getCmd { keyCmds, cmdKey } event =
    case Dict.get (eventToString cmdKey event) keyCmds of
        Just cmd ->
            cmd

        Nothing ->
            NoCmd


eventToString : (KeyEvent -> Bool) -> KeyEvent -> String
eventToString cmdKey payload =
    let
        direction =
            toString payload.direction

        code =
            toString payload.code

        shift =
            toString payload.shift

        cmd =
            toString (cmdKey payload)
    in
    shift ++ cmd ++ code ++ direction



-- Keys from Cmd --


getKeysLabel : Config -> KeyCmd -> String
getKeysLabel { cmdKey, quickKeys } cmd =
    quickKeys
        |> Dict.get (toString cmd)
        |> Maybe.withDefault ""
