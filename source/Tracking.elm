module Tracking
    exposing
        ( Event(..)
        , Payload
        , encode
        )

import Id exposing (Id, Origin)
import Json.Encode as Encode exposing (Value)
import Json.Encode.Extra as Encode
import Tuple.Infix exposing ((:=))
import Util


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
    [ "event" := encodeEvent event
    , "sessionId" := Id.encode sessionId
    , "email" := Encode.maybe Encode.string email
    , "drawingId" := Util.encodeOrigin drawingId
    ]
        |> Encode.object


encodeEvent : Event -> Value
encodeEvent event =
    case event of
        AppLoaded ->
            [ "name" := Encode.string "app loaded" ]
                |> Encode.object

        AppFailedToInitialize problem ->
            [ "name" := Encode.string "app failed to load"
            , "problem" := Encode.string problem
            ]
                |> Encode.object
