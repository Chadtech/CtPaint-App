module Data.User
    exposing
        ( Model
        , State(..)
        , User
        , decoder
        , getEmail
        , initModel
        , isLoggedIn
        , stateDecoder
        , toggleOptionsDropped
        )

import Data.Keys as Keys
import Id exposing (Origin(Local, Remote))
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline
    exposing
        ( custom
        , decode
        , hardcoded
        , required
        )
import Keyboard.Extra.Browser exposing (Browser)


type State
    = Offline
    | AllowanceExceeded
    | LoggedOut
    | LoggingIn
    | LoggingOut
    | LoggedIn Model


type alias Model =
    { user : User
    , optionsDropped : Bool
    , drawingId : Origin
    }


type alias User =
    { email : String
    , name : String
    , profilePic : String
    , keyConfig : Keys.Config
    }


initModel : Origin -> User -> Model
initModel origin user =
    { user = user
    , optionsDropped = False
    , drawingId = origin
    }


getEmail : State -> Maybe String
getEmail model =
    case model of
        LoggedIn { user } ->
            Just user.email

        _ ->
            Nothing


stateDecoder : Origin -> Browser -> Decoder State
stateDecoder drawingId browser =
    [ Decode.null LoggedOut
    , Decode.string |> Decode.andThen fromString
    , decoder browser
        |> Decode.map (initModel drawingId)
        |> Decode.map LoggedIn
    ]
        |> Decode.oneOf


fromString : String -> Decoder State
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


isLoggedIn : State -> Bool
isLoggedIn state =
    case state of
        LoggedIn _ ->
            True

        _ ->
            False


toggleOptionsDropped : Model -> Model
toggleOptionsDropped model =
    { model | optionsDropped = not model.optionsDropped }
