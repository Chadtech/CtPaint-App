module Data.Tracking exposing
    ( Event
    , Payload
    , encode
    , namespace
    , noProps
    , none
    , toMaybe
    , withProps
    )

import Id exposing (Id)
import Json.Encode as E
import Json.Encode.Extra as EE
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
    , properties : List ( String, E.Value )
    , sessionId : Id
    , email : Maybe String
    }


type Event
    = None
    | Event String (List ( String, E.Value ))


toMaybe : Event -> Maybe ( String, List ( String, E.Value ) )
toMaybe event =
    case event of
        None ->
            Nothing

        Event name props ->
            Just ( name, props )


none : Event
none =
    None


withProps : String -> List ( String, E.Value ) -> Event
withProps =
    Event


noProps : String -> Event
noProps name =
    Event name []



-- HELPERS --
-- response : Maybe String -> Maybe Event
-- response maybeError =
--     maybeError
--         |> EE.maybe E.string
--         |> def "error"
--         |> List.singleton
--         |> def "response"
--         |> Just


namespace : String -> Event -> Event
namespace prefix event =
    case event of
        None ->
            None

        Event name properties ->
            Event (prefix ++ " " ++ name) properties



-- PUBLIC --


encode : Payload -> E.Value
encode payload =
    [ payload.name
        |> Util.replace " " "_"
        |> E.string
        |> def "name"
    , def "properties" <| encodeProperties payload
    ]
        |> E.object


encodeProperties : Payload -> E.Value
encodeProperties payload =
    [ def "sessionId" <| Id.encode payload.sessionId
    , def "email" <| EE.maybe E.string payload.email
    ]
        |> List.append payload.properties
        |> E.object
