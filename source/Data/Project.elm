module Data.Project
    exposing
        ( Project
        , decoder
        , encode
        , init
        , loading
        , setName
        )

import Id as Id exposing (Id, Origin(..))
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode exposing (Value)
import Tuple.Infix exposing ((:=))


type alias Project =
    { name : String
    , nameIsGenerated : Bool
    , origin : Origin
    }


init : String -> Project
init name =
    { name = name
    , nameIsGenerated = True
    , origin = Local
    }


loading : Id -> Project
loading id =
    { name = ""
    , nameIsGenerated = False
    , origin = Remote id
    }



-- ENCODER --


encode : Project -> Value
encode { name, origin, nameIsGenerated } =
    [ "name" := Encode.string name
    , "nameIsGenerated" := Encode.bool nameIsGenerated
    , "id" := encodeOrigin origin
    ]
        |> Encode.object


encodeOrigin : Origin -> Value
encodeOrigin origin =
    case origin of
        Remote id ->
            Id.encode id

        Local ->
            Encode.null



-- DECODER --


decoder : Decoder Project
decoder =
    decode Project
        |> required "name" Decode.string
        |> required "nameIsGenerated" Decode.bool
        |> required "id" (Decode.map Remote Id.decoder)


setName : String -> Project -> Project
setName name project =
    { project | name = name }
