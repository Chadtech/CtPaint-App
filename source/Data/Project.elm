module Data.Project
    exposing
        ( Project
        , decoder
        , encode
        , setName
        )

import Id as Id exposing (Id)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode exposing (Value)
import Tuple.Infix exposing ((:=))


type alias Project =
    { name : String
    , id : Id
    , version : Int
    }



-- ENCODER --


encode : Project -> Value
encode { name, id, version } =
    [ "name" := Encode.string name
    , "id" := Id.encode id
    , "version" := Encode.int version
    ]
        |> Encode.object



-- DECODER --


decoder : Decoder Project
decoder =
    decode Project
        |> required "name" Decode.string
        |> required "id" Id.decoder
        |> required "version" Decode.int


setName : String -> Project -> Project
setName name project =
    { project | name = name }
