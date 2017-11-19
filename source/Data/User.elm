module Data.User exposing (User, decoder, toggleOptionsDropped)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline
    exposing
        ( decode
        , hardcoded
        , required
        )


type Model
    = NoSession
    | Offline
    | LoggingIn
    | LoggingOut
    | LoggedIn User


type alias User =
    { email : String
    , name : String
    , profilePic : String
    , optionsDropped : Bool
    }


decoder : Decoder User
decoder =
    decode User
        |> required "email" Decode.string
        |> required "nickname" Decode.string
        |> hardcoded "no profile pic yet"
        |> hardcoded False



-- HELPERS --


toggleOptionsDropped : User -> User
toggleOptionsDropped user =
    { user | optionsDropped = not user.optionsDropped }
