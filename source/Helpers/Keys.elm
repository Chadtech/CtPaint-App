module Helpers.Keys
    exposing
        ( getCmd
        , getKeysLabel
        , setShift
        )

import Data.Config exposing (Config)
import Data.Keys as Key exposing (Cmd(NoCmd))
import Dict
import Model exposing (Model)


setShift : Key.Event -> Model -> Model
setShift event model =
    { model | shiftIsDown = event.shift }



-- keyCmd from Event --


getCmd : Config -> Key.Event -> Key.Cmd
getCmd { keyCmds, cmdKey } event =
    case Dict.get (eventToString cmdKey event) keyCmds of
        Just cmd ->
            cmd

        Nothing ->
            NoCmd


eventToString : (Key.Event -> Bool) -> Key.Event -> String
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


getKeysLabel : Config -> Key.Cmd -> String
getKeysLabel { cmdKey, quickKeys } cmd =
    quickKeys
        |> Dict.get (toString cmd)
        |> Maybe.withDefault ""
