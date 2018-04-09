module Data.Taco
    exposing
        ( Taco
        , fromFlags
        , setUser
        )

import Data.Config as Config exposing (Config)
import Data.Flags exposing (Flags)
import Data.User as User
import Tracking


type alias Taco =
    { config : Config
    , user : User.State
    }


fromFlags : Flags -> Taco
fromFlags flags =
    { config = Config.init flags
    , user = flags.user
    }


setUser : Taco -> User.State -> Taco
setUser taco state =
    { taco | user = state }
