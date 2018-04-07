module Tracking
    exposing
        ( Event(..)
        , Payload
        , encode
        )

import Id exposing (Id, Origin)
import Json.Encode as Encode exposing (Value)
import Json.Encode.Extra as Encode
import Util exposing (def)


type alias Payload =
    { event : Event
    , sessionId : Id
    , email : Maybe String
    , drawingId : Origin
    }


type Event
    = AppLoaded
    | AppFailedToInitialize String


encode : Payload -> Value
encode { event, sessionId, email, drawingId } =
    [ def "event" <| encodeEvent event
    , def "sessionId" <| Id.encode sessionId
    , def "email" <| Encode.maybe Encode.string email
    , def "drawingId" <| Util.encodeOrigin drawingId
    ]
        |> Encode.object


encodeEvent : Event -> Value
encodeEvent event =
    case event of
        AppLoaded ->
            [ def "name" <| Encode.string "app loaded" ]
                |> Encode.object

        AppFailedToInitialize problem ->
            [ def "name" <| Encode.string "app failed to load"
            , def "problem" <| Encode.string problem
            ]
                |> Encode.object
