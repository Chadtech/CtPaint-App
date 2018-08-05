module Data.Tracking
    exposing
        ( Event
        , Payload
        , encode
        , namespace
        , noProps
        , response
        )

import Id exposing (Id)
import Json.Encode as Encode exposing (Value)
import Json.Encode.Extra as Encode
import Util exposing (def)


{-|

    Tracking refers to tracking UX events, like
    clicks, and navigations, and http responses.
    Those events are listened to, and then sent
    to the backend to be stored. This tracking
    data is really useful for development.
    Errors, for example, are tracked. There
    are always really ugly errors the user
    experiences that the developer is totally
    unaware of. More generally tho, knowing how
    users use the application helps developers
    know what to develop. It helps developers
    know what users want.

-}



-- TYPES --


type alias Payload =
    { name : String
    , properties : List ( String, Value )
    , sessionId : Id
    , email : Maybe String
    }


type alias Event =
    ( String, List ( String, Value ) )



-- HELPERS --


noProps : String -> Maybe Event
noProps name =
    Just (def name [])


response : Maybe String -> Maybe Event
response maybeError =
    maybeError
        |> Encode.maybe Encode.string
        |> def "error"
        |> List.singleton
        |> def "response"
        |> Just


namespace : String -> Maybe Event -> Maybe Event
namespace name =
    Maybe.map (Tuple.mapFirst ((++) (name ++ " ")))



-- PUBLIC --


encode : Payload -> Value
encode payload =
    [ payload.name
        |> Util.replace " " "_"
        |> Encode.string
        |> def "name"
    , def "properties" <| encodeProperties payload
    ]
        |> Encode.object


encodeProperties : Payload -> Value
encodeProperties payload =
    [ def "sessionId" <| Id.encode payload.sessionId
    , def "email" <| Encode.maybe Encode.string payload.email
    ]
        |> List.append payload.properties
        |> Encode.object
