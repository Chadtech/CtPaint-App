module Data.Project
    exposing
        ( Project
        , decoder
        , encode
        )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode exposing (Value)
import Tuple.Infix exposing ((:=))


type alias Project =
    { name : String
    , id : String
    , version : Int
    }



-- ENCODER --


encode : Project -> Value
encode { name, id, version } =
    [ "name" := Encode.string name
    , "id" := Encode.string id
    , "version" := Encode.int version
    ]
        |> Encode.object



-- DECODER --


decoder : Decoder Project
decoder =
    decode Project
        |> required "name" Decode.string
        |> required "id" Decode.string
        |> required "version" Decode.int
