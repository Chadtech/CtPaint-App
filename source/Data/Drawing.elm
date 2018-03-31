module Data.Drawing
    exposing
        ( Drawing
        , State(..)
        , decoder
        , fromMaybe
        , toOrigin
        )

import Id exposing (Id)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)


-- TYPES --


type alias Drawing =
    { id : Id
    , publicId : Id
    , data : String
    , name : String
    , nameIsGenerated : Bool
    }


type State
    = Local
    | Remote Id
    | Loaded Drawing



-- DECODER --


decoder : Decoder Drawing
decoder =
    decode Drawing
        |> required "drawingId" Id.decoder
        |> required "publicId" Id.decoder
        |> required "canvas" Decode.string
        |> required "name" Decode.string
        |> required "nameIsGenerated" Decode.bool



-- HELPERS --


toOrigin : State -> Id.Origin
toOrigin state =
    case state of
        Local ->
            Id.Local

        Remote id ->
            Id.Remote id

        Loaded { id } ->
            Id.Remote id


fromMaybe : Maybe Id -> State
fromMaybe maybeId =
    case maybeId of
        Just id ->
            Remote id

        Nothing ->
            Local
