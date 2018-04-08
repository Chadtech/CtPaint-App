module Data.Taco
    exposing
        ( Taco
        , fromFlags
        )

import Data.Config as Config exposing (Config)
import Data.Flags exposing (Flags)
import Data.User as User
import Tracking


type alias Taco =
    { config : Config
    , trackingCtor : Tracking.Ctor
    }


fromFlags : Flags -> Taco
fromFlags flags =
    let
        config =
            Config.init flags
    in
    { config = config
    , trackingCtor =
        Tracking.makeCtor
            config.sessionId
            (User.getEmail flags.user)
    }
