module Data.User
    exposing
        ( Model(..)
        , User
        , decoder
        , getEmail
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
import Keyboard.Extra.Browser exposing (Browser)


type Model
    = Offline
    | AllowanceExceeded
    | LoggedOut
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


getEmail : Model -> Maybe String
getEmail model =
    case model of
        LoggedIn user ->
            Just user.email

        _ ->
            Nothing


modelDecoder : Browser -> Decoder Model
modelDecoder browser =
    [ Decode.null LoggedOut
    , Decode.string |> Decode.andThen fromString
    , decoder browser |> Decode.map LoggedIn
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


decoder : Browser -> Decoder User
decoder browser =
    decode User
        |> required "email" Decode.string
        |> required "name" Decode.string
        |> required "picture" Decode.string
        |> hardcoded False
        |> custom (configDecoder browser)



-- CONFIG DECODING --


configDecoder : Browser -> Decoder Keys.Config
configDecoder browser =
    decode (,,,)
        |> required "custom:keyconfig0" keyConfigPartDecoder
        |> required "custom:keyconfig1" keyConfigPartDecoder
        |> required "custom:keyconfig2" keyConfigPartDecoder
        |> required "custom:keyconfig3" keyConfigPartDecoder
        |> Decode.andThen (fromPartsToKeyConfig browser)


fromPartsToKeyConfig :
    Browser
    -> ( String, String, String, String )
    -> Decoder Keys.Config
fromPartsToKeyConfig browser ( p0, p1, p2, p3 ) =
    [ p0, p1, p2, p3 ]
        |> String.concat
        |> Decode.decodeString
            (Keys.configDecoder browser)
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
