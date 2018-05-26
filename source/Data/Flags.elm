module Data.Flags
    exposing
        ( Flags
        , Init(..)
        , decoder
        , projectNameGenerator
        )

import Data.Color
    exposing
        ( BackgroundColor(Black, White)
        , backgroundColorDecoder
        )
import Data.Drawing as Drawing
import Data.User as User
import Helpers.Canvas exposing (Params)
import Helpers.Random as Random
import Id exposing (Id, Origin(Local, Remote))
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline
    exposing
        ( custom
        , decode
        , optional
        , optionalAt
        , required
        )
import Keyboard.Extra.Browser exposing (Browser(Chrome, FireFox))
import Random.Pcg as Random exposing (Generator, Seed)
import Util
import Window exposing (Size)


type alias Flags =
    { windowSize : Size
    , isMac : Bool
    , browser : Browser
    , user : User.State
    , init : Init
    , mountPath : String
    , buildNumber : Int
    , randomValues : RandomValues
    }


type alias RandomValues =
    { sessionId : Id
    , projectName : String
    , seed : Seed
    }


type Init
    = NormalInit
    | FromId Id
    | FromUrl String
    | FromParams Params



-- DECODER --


decoder : Decoder Flags
decoder =
    decode Flags
        |> custom windowDecoder
        |> optional "isMac" Decode.bool True
        |> required "browser" browserDecoder
        |> custom userDecoder
        |> required "init" initDecoder
        |> required "mountPath" Decode.string
        |> required "buildNumber" Decode.int
        |> required "seed" randomValuesDecoder


randomValuesDecoder : Decoder RandomValues
randomValuesDecoder =
    seedDecoder
        |> Decode.map toRandomValues


toRandomValues : Seed -> RandomValues
toRandomValues seed =
    RandomValues
        |> Random.from seed
        |> Random.value Id.generator
        |> Random.value projectNameGenerator
        |> Random.finish


projectNameGenerator : Generator String
projectNameGenerator =
    Util.uuidGenerator 16


userDecoder : Decoder User.State
userDecoder =
    decode (,)
        |> required "browser" browserDecoder
        |> optionalAt [ "init", "id" ] (Decode.map Just Id.decoder) Nothing
        |> Decode.andThen toUserState


toUserState : ( Browser, Maybe Id ) -> Decoder User.State
toUserState ( browser, maybeId ) =
    User.stateDecoder (Drawing.fromMaybe maybeId) browser
        |> Decode.field "user"


browserDecoder : Decoder Browser
browserDecoder =
    Decode.string
        |> Decode.andThen toBrowser


toBrowser : String -> Decoder Browser
toBrowser browser =
    case browser of
        "Firefox" ->
            Decode.succeed FireFox

        "Chrome" ->
            Decode.succeed Chrome

        "Unknown" ->
            Decode.succeed Chrome

        other ->
            Decode.fail ("Unknown browser type " ++ other)


initDecoder : Decoder Init
initDecoder =
    [ Decode.null NormalInit
    , Id.decoder
        |> Decode.field "id"
        |> Decode.map FromId
    , Decode.string
        |> Decode.field "url"
        |> Decode.map (Util.replace "%2F" "/")
        |> Decode.map FromUrl
    , paramsDecoder
        |> Decode.map FromParams
    ]
        |> Decode.oneOf


paramsDecoder : Decoder Params
paramsDecoder =
    decode Params
        |> optional_ "name" Decode.string
        |> optional_ "width" Decode.int
        |> optional_ "height" Decode.int
        |> optional_ "background" backgroundColorDecoder


optional_ : String -> Decoder a -> Decoder (Maybe a -> b) -> Decoder b
optional_ field decoder =
    optional field (Decode.map Just decoder) Nothing


seedDecoder : Decoder Seed
seedDecoder =
    Decode.map Random.initialSeed Decode.int


windowDecoder : Decoder Size
windowDecoder =
    Decode.map2 Size
        (Decode.field "windowWidth" Decode.int)
        (Decode.field "windowHeight" Decode.int)
