module PaintApp exposing (..)

import Array exposing (Array)
import Canvas exposing (Canvas, DrawOp(..), Point, Size)
import Color
import ColorPicker
import Html
import Json.Decode as Decode exposing (Decoder, Value, value)
import Msg exposing (Msg(..))
import Random
import Subscriptions exposing (subscriptions)
import Tool
import Tuple.Infix exposing ((&))
import Types
    exposing
        ( HistoryOp(..)
        , MinimapState(..)
        , Model
        , decodeIsMac
        , decodeWindow
        , defaultKeyConfig
        , defaultQuickKeys
        , fillBlack
        , initPalette
        , initSwatches
        )
import Update exposing (update)
import Util exposing (tbw)
import View exposing (view)


-- MAIN --


main : Program Value Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- INIT --


init : Value -> ( Model, Cmd Msg )
init json =
    let
        windowSize : Size
        windowSize =
            decodeWindow json

        ( canvas, menu ) =
            case Err "dont load it right now" of
                Ok canvas ->
                    canvas & Nothing

                Err err ->
                    Canvas.initialize
                        { width = 400
                        , height = 400
                        }
                        |> fillBlack
                        & Nothing

        canvasSize : Size
        canvasSize =
            Canvas.getSize canvas

        isMac : Bool
        isMac =
            decodeIsMac json
    in
    { user = Nothing
    , canvas = canvas
    , projectName = Nothing
    , canvasPosition =
        { x =
            ((windowSize.width - tbw) - canvasSize.width) // 2
        , y =
            (windowSize.height - canvasSize.height) // 2
        }
    , pendingDraw = Canvas.batch []
    , drawAtRender = Canvas.batch []
    , swatches = initSwatches
    , palette = initPalette
    , horizontalToolbarHeight = 58
    , windowSize = windowSize
    , tool = Tool.init
    , zoom = 1
    , galleryView = False
    , colorPicker =
        case Array.get 0 initPalette of
            Just color ->
                ColorPicker.init
                    False
                    0
                    color

            Nothing ->
                ColorPicker.init
                    False
                    0
                    Color.black
    , history = [ CanvasChange canvas ]
    , future = []
    , mousePosition = Nothing
    , selection = Nothing
    , clipboard = Nothing
    , taskbarDropped = Nothing
    , minimap = NoMinimap
    , menu = menu
    , seed = Random.initialSeed (decodeSeed json)
    , config =
        { keyOps = defaultKeyConfig
        , quickKeys = defaultQuickKeys isMac
        , cmdKey =
            if isMac then
                .meta
            else
                .ctrl
        }
    }
        & Cmd.none



-- SEED DECODER --


decodeSeed : Value -> Int
decodeSeed json =
    case Decode.decodeValue seedDecoder json of
        Ok seed ->
            seed

        Err _ ->
            1776


seedDecoder : Decoder Int
seedDecoder =
    Decode.field "seed" Decode.int
