module Data.Config exposing (Config, init)

import Data.Flags exposing (Flags)
import Data.Keys as Key
import Data.User exposing (Model(..))
import Dict exposing (Dict)


type alias Config =
    { quickKeys : Dict String String
    , keyCmds : Dict String Key.Cmd
    , cmdKey : Key.Event -> Bool
    }


init : Flags -> Config
init flags =
    let
        keyConfig =
            getKeyConfig flags
    in
    { quickKeys = Key.initQuickKeysLookUp keyConfig flags.isMac
    , keyCmds = Key.initCmdLookUp keyConfig
    , cmdKey =
        if flags.isMac then
            .meta
        else
            .ctrl
    }


getKeyConfig : Flags -> Key.Config
getKeyConfig flags =
    case flags.user of
        LoggedIn user ->
            user.keyConfig

        _ ->
            Key.defaultConfig
