module Data.Id
    exposing
        ( Id
        , decoder
        , encode
        , fromString
        )

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)


type Id
    = Id String


fromString : String -> Id
fromString =
    Id


encode : Id -> Value
encode (Id str) =
    Encode.string str


decoder : Decoder Id
decoder =
    Decode.map fromString Decode.string
