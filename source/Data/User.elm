module Data.User exposing (User, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline
    exposing
        ( decode
        , hardcoded
        , required
        )


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
