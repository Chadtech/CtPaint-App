module Data.User exposing
    ( Model
    , State(..)
    , User
    , decoder
    , drawingLoaded
    , getDrawingOrigin
    , getEmail
    , getPublicId
    , initModel
    , isLoggedIn
    , setDrawing
    , stateDecoder
    , toggleOptionsDropped
    )

import Data.Drawing as Drawing exposing (Drawing)
import Data.Keys as Keys
import Id exposing (Id, Origin(Local))
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
    , drawing : Drawing.State
    }


type alias User =
    { email : String
    , name : String
    , keyConfig : Keys.Config
    }


initModel : Drawing.State -> User -> Model
initModel drawingState user =
    { user = user
    , optionsDropped = False
    , drawing = drawingState
    }


getEmail : State -> Maybe String
getEmail model =
    case model of
        LoggedIn { user } ->
            Just user.email

        _ ->
            Nothing


stateDecoder : Drawing.State -> Browser -> Decoder State
stateDecoder drawingState browser =
    [ Decode.null LoggedOut
    , Decode.string
        |> Decode.andThen fromString
    , decoder browser
        |> Decode.map (initModel drawingState)
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
            Decode.fail (decodeFailMsg str)


decodeFailMsg : String -> String
decodeFailMsg =
    (++) "user state is not offline or allowance exceeded -> "


decoder : Browser -> Decoder User
decoder browser =
    decode User
        |> required "email" Decode.string
        |> required "name" Decode.string
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


drawingLoaded : State -> Bool
drawingLoaded state =
    case state of
        LoggedIn { drawing } ->
            case drawing of
                Drawing.Loaded _ ->
                    True

                _ ->
                    False

        _ ->
            False


getPublicId : State -> Maybe Id
getPublicId state =
    case state of
        LoggedIn { drawing } ->
            case drawing of
                Drawing.Loaded { publicId } ->
                    Just publicId

                _ ->
                    Nothing

        _ ->
            Nothing


getDrawingOrigin : State -> Origin
getDrawingOrigin state =
    case state of
        LoggedIn { drawing } ->
            Drawing.toOrigin drawing

        _ ->
            Local


setDrawing : Drawing -> Model -> Model
setDrawing drawing model =
    { model | drawing = Drawing.Loaded drawing }


toggleOptionsDropped : Model -> Model
toggleOptionsDropped model =
    { model | optionsDropped = not model.optionsDropped }
