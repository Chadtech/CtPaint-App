module Types.Session exposing (..)

import Json.Decode as Decode exposing (Decoder, Value)


type alias Session =
    { email : String }



-- DECODER --


decoder : Decoder Session
decoder =
    Decode.map Session <|
        Decode.field
            "email"
            Decode.string


decode : Value -> Maybe Session
decode =
    Decode.decodeValue decoder >> Result.toMaybe
