module Data.User
    exposing
        ( Model(..)
        , User
        , decoder
        , modelDecoder
        , toggleOptionsDropped
        )

import Data.Keys as Keys
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline
    exposing
        ( custom
        , decode
        , hardcoded
        , required
        )


type Model
    = NoSession
    | Offline
    | AllowanceExceeded
    | LoggingIn
    | LoggingOut
    | LoggedIn User


type alias User =
    { email : String
    , name : String
    , profilePic : String
    , optionsDropped : Bool
    , keyConfig : Keys.Config
    }


modelDecoder : Decoder Model
modelDecoder =
    [ Decode.null NoSession
    , Decode.string |> Decode.andThen fromString
    , decoder |> Decode.map LoggedIn
    ]
        |> Decode.oneOf


fromString : String -> Decoder Model
fromString str =
    case str of
        "offline" ->
            Decode.succeed Offline

        "allowance exceeded" ->
            Decode.succeed AllowanceExceeded

        _ ->
            Decode.fail "not offline or allowance exceeded"


decoder : Decoder User
decoder =
    decode User
        |> required "email" Decode.string
        |> required "name" Decode.string
        |> required "picture" Decode.string
        |> hardcoded False
        |> custom configDecoder



-- CONFIG DECODING --


configDecoder : Decoder Keys.Config
configDecoder =
    decode (,,,)
        |> required "custom:keyconfig0" keyConfigPartDecoder
        |> required "custom:keyconfig1" keyConfigPartDecoder
        |> required "custom:keyconfig2" keyConfigPartDecoder
        |> required "custom:keyconfig3" keyConfigPartDecoder
        |> Decode.andThen fromPartsToKeyConfig


fromPartsToKeyConfig : ( String, String, String, String ) -> Decoder Keys.Config
fromPartsToKeyConfig ( p0, p1, p2, p3 ) =
    [ p0, p1, p2, p3 ]
        |> String.concat
        |> Decode.decodeString Keys.configDecoder
        |> resultToDecoder


resultToDecoder : Result String Keys.Config -> Decoder Keys.Config
resultToDecoder result =
    case result of
        Ok config ->
            Decode.succeed config

        Err err ->
            Decode.fail err


keyConfigPartDecoder : Decoder String
keyConfigPartDecoder =
    Decode.map ifNotEnded Decode.string


ifNotEnded : String -> String
ifNotEnded str =
    case str of
        "CONFIG ENDED" ->
            ""

        other ->
            other



-- HELPERS --


toggleOptionsDropped : User -> User
toggleOptionsDropped user =
    { user | optionsDropped = not user.optionsDropped }
