module Data.Config exposing (Config, init)

import Data.Flags exposing (Flags)
import Data.Keys as Keys exposing (KeyCmd, KeyEvent)
import Data.User exposing (Model(..))
import Dict exposing (Dict)


type alias Config =
    { quickKeys : Dict String String
    , keyCmds : Dict String KeyCmd
    , cmdKey : KeyEvent -> Bool
    }


init : Flags -> Config
init flags =
    let
        keyConfig =
            getKeyConfig flags
    in
    { quickKeys = Keys.initQuickKeysLookUp keyConfig flags.isMac
    , keyCmds = Keys.initCmdLookUp keyConfig
    , cmdKey =
        if flags.isMac then
            .meta
        else
            .ctrl
    }


getKeyConfig : Flags -> Keys.Config
getKeyConfig flags =
    case flags.user of
        LoggedIn user ->
            user.keyConfig

        _ ->
            Keys.defaultConfig
