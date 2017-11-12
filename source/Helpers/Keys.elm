module Helpers.Keys exposing (cmdFromEvent)

import Data.Config exposing (Config)
import Data.Keys exposing (KeyCmd(NoCmd), KeyEvent)
import Dict


cmdFromEvent : KeyEvent -> Config -> KeyCmd
cmdFromEvent event { cmdKey, keyCmds } =
    case Dict.get (eventToString cmdKey event) keyCmds of
        Just keyCmd ->
            keyCmd

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
