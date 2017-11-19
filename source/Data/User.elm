module Data.User
    exposing
        ( Model(..)
        , User
        , decoder
        , toggleOptionsDropped
        )

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


decoder : Decoder Model
decoder =
    [ Decode.null NoSession
    , Decode.string |> Decode.andThen offlineDecoder
    , userDecoder |> Decode.map LoggedIn
    ]
        |> Decode.oneOf


offlineDecoder : String -> Decoder Model
offlineDecoder str =
    if str == "offline" then
        Decode.succeed Offline
    else
        Decode.fail "not offline"


userDecoder : Decoder User
userDecoder =
    decode User
        |> required "email" Decode.string
        |> required "nickname" Decode.string
        |> hardcoded "no profile pic yet"
        |> hardcoded False



-- HELPERS --


toggleOptionsDropped : User -> User
toggleOptionsDropped user =
    { user | optionsDropped = not user.optionsDropped }
