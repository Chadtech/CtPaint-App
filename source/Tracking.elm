module Tracking
    exposing
        ( Event(..)
        , Payload
        , Session
        , encode
        )

import Json.Encode as Encode exposing (Value)
import Tuple.Infix exposing ((:=))


type alias Payload =
    { event : Event
    , session : Maybe Session
    }


type alias Session =
    { email : String
    , projectId : Maybe String
    }


type Event
    = AppLoaded
    | AppFailedToLoad String


encode : Payload -> Value
encode { event, session } =
    [ "event" := encodeEvent event
    , "session" := encodeSession session
    ]
        |> Encode.object


encodeSession : Maybe Session -> Value
encodeSession maybeSession =
    case maybeSession of
        Just session ->
            [ "email" := Encode.string session.email
            , "project id" := encodeProjectId session.projectId
            ]
                |> Encode.object

        Nothing ->
            Encode.null


encodeProjectId : Maybe String -> Value
encodeProjectId maybeProjectId =
    case maybeProjectId of
        Just projectId ->
            Encode.string projectId

        Nothing ->
            Encode.null


encodeEvent : Event -> Value
encodeEvent event =
    case event of
        AppLoaded ->
            [ "name" := Encode.string "app loaded" ]
                |> Encode.object

        AppFailedToLoad problem ->
            [ "name" := Encode.string "app failed to load"
            , "problem" := Encode.string problem
            ]
                |> Encode.object
