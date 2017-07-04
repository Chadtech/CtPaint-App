module Main.Init exposing (..)

import Main.Model exposing (Model)
import Main.Message exposing (Message(..))
import Json.Decode exposing (Value)
import Canvas exposing (Size)
import Types.Session as Session
import Json.Decode as Decode exposing (Decoder)


init : Value -> ( Model, Cmd Message )
init json =
    { session = Session.decode json
    , canvas = Canvas.initialize (Size 400 400)
    , pendingDraw = Canvas.batch []
    , palette = []
    , horizontalToolbarHeight = 58
    , subMouseMove = Nothing
    , windowHeight =
        case Decode.decodeValue heightDecoder json of
            Ok height ->
                height

            _ ->
                800
    }
        ! []



-- HEIGHT DECODER --


heightDecoder : Decoder Int
heightDecoder =
    Decode.field "windowHeight" Decode.int
