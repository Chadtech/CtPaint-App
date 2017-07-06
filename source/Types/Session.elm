module Types.Session exposing (..)

import Json.Decode as Decode exposing (Decoder, Value)


type alias Session =
    { email : String }



-- DECODER --


decoder : Decoder Session
decoder =
    Decode.field "email" Decode.string
        |> Decode.map Session


decode : Value -> Maybe Session
decode =
    Decode.decodeValue decoder >> Result.toMaybe
