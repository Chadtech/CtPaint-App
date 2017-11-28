module Data.Flags exposing (Flags, decoder)

import Data.User as User
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (custom, decode, optional, required)
import Random exposing (Seed)
import Window exposing (Size)


type alias Flags =
    { windowSize : Size
    , seed : Seed
    , isMac : Bool
    , isChrome : Bool
    , user : User.Model
    , init : Init
    }


type Init
    = New
    | Existing String
    | None



-- DECODER --


decoder : Decoder Flags
decoder =
    decode Flags
        |> custom windowDecoder
        |> optional "seed" seedDecoder (Random.initialSeed 1776)
        |> optional "isMac" Decode.bool True
        |> optional "isChrome" Decode.bool True
        |> required "user" User.decoder
        |> required "init" initDecoder


initDecoder : Decoder Init
initDecoder =
    Decode.string
        |> Decode.field "type"
        |> Decode.andThen toInit


toInit : String -> Decoder Init
toInit type_ =
    case type_ of
        "new" ->
            Decode.succeed New

        "image" ->
            Decode.string
                |> Decode.field "id"
                |> Decode.map Existing

        "none" ->
            Decode.succeed None

        _ ->
            Decode.fail ("Unknown init type : " ++ type_)


seedDecoder : Decoder Seed
seedDecoder =
    Decode.map Random.initialSeed Decode.int


windowDecoder : Decoder Size
windowDecoder =
    Decode.map2 Size
        (Decode.field "windowWidth" Decode.int)
        (Decode.field "windowHeight" Decode.int)
