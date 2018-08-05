module Data.Drawing
    exposing
        ( Drawing
        , State(..)
        , decoder
        , fromMaybe
        , toOrigin
        )

import Id exposing (Id)
import Json.Decode as JD exposing (Decoder)
import Json.Decode.Pipeline as JDP exposing (decode)


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
        |> JDP.required "drawingId" Id.decoder
        |> JDP.required "publicId" Id.decoder
        |> JDP.required "canvas" JD.string
        |> JDP.required "name" JD.string
        |> JDP.required "nameIsGenerated" JD.bool



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
