module Data.Flags
    exposing
        ( Flags
        , Init(..)
        , decoder
        , projectNameGenerator
        )

import Canvas.Data.Params as CanvasParams
    exposing
        ( CanvasParams
        )
import Data.Drawing as Drawing
import Data.User as User
import Helpers.Random as Random
import Id exposing (Id, Origin(Local, Remote))
import Json.Decode as JD exposing (Decoder)
import Json.Decode.Pipeline as JDP
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
    | FromParams CanvasParams



-- DECODER --


decoder : Decoder Flags
decoder =
    JDP.decode Flags
        |> JDP.custom windowDecoder
        |> JDP.optional "isMac" JD.bool True
        |> JDP.required "browser" browserDecoder
        |> JDP.custom userDecoder
        |> JDP.required "init" initDecoder
        |> JDP.required "mountPath" JD.string
        |> JDP.required "buildNumber" JD.int
        |> JDP.required "seed" randomValuesDecoder


randomValuesDecoder : Decoder RandomValues
randomValuesDecoder =
    seedDecoder
        |> JD.map toRandomValues


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
    JDP.decode (,)
        |> JDP.required "browser" browserDecoder
        |> JDP.optionalAt [ "init", "id" ] (JD.map Just Id.decoder) Nothing
        |> JD.andThen toUserState


toUserState : ( Browser, Maybe Id ) -> Decoder User.State
toUserState ( browser, maybeId ) =
    User.stateDecoder (Drawing.fromMaybe maybeId) browser
        |> JD.field "user"


browserDecoder : Decoder Browser
browserDecoder =
    JD.string
        |> JD.andThen toBrowser


toBrowser : String -> Decoder Browser
toBrowser browser =
    case browser of
        "Firefox" ->
            JD.succeed FireFox

        "Chrome" ->
            JD.succeed Chrome

        "Unknown" ->
            JD.succeed Chrome

        other ->
            JD.fail ("Unknown browser type " ++ other)


initDecoder : Decoder Init
initDecoder =
    [ JD.null NormalInit
    , Id.decoder
        |> JD.field "id"
        |> JD.map FromId
    , JD.string
        |> JD.field "url"
        |> JD.map (Util.replace "%2F" "/")
        |> JD.map FromUrl
    , CanvasParams.decoder
        |> JD.map FromParams
    ]
        |> JD.oneOf


seedDecoder : Decoder Seed
seedDecoder =
    JD.map Random.initialSeed JD.int


windowDecoder : Decoder Size
windowDecoder =
    JD.map2 Size
        (JD.field "windowWidth" JD.int)
        (JD.field "windowHeight" JD.int)
