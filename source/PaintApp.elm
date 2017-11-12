module PaintApp exposing (..)

import Array exposing (Array)
import Canvas exposing (Canvas, DrawOp(..), Point, Size)
import Color
import ColorPicker
import Data.Flags as Flags exposing (Flags)
import Data.Keys exposing (defaultKeyCmdConfig, defaultQuickKeys)
import Data.Palette exposing (initPalette, initSwatches)
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
        , fillBlack
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
    case Decode.decodeValue Flags.decoder json of
        Ok flags ->
            fromFlags flags

        Err err ->
            fromError (Debug.log "error" err)


fromFlags : Flags -> ( Model, Cmd Msg )
fromFlags flags =
    let
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
    in
    { user = Nothing
    , canvas = canvas
    , projectName = Nothing
    , canvasPosition =
        { x =
            ((flags.windowSize.width - tbw) - canvasSize.width) // 2
        , y =
            (flags.windowSize.height - canvasSize.height) // 2
        }
    , pendingDraw = Canvas.batch []
    , drawAtRender = Canvas.batch []
    , swatches = initSwatches
    , palette = initPalette
    , horizontalToolbarHeight = 58
    , windowSize = flags.windowSize
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
    , menu = Nothing
    , seed = flags.seed
    , config =
        { keyCmds = defaultKeyCmdConfig
        , quickKeys = defaultQuickKeys flags.isMac
        , cmdKey =
            if flags.isMac then
                .meta
            else
                .ctrl
        }
    }
        & Cmd.none


fromError : String -> ( Model, Cmd Msg )
fromError err =
    { user = Nothing
    , canvas =
        Canvas.initialize
            { width = 400
            , height = 400
            }
    , projectName = Nothing
    , canvasPosition = { x = 0, y = 0 }
    , pendingDraw = Canvas.batch []
    , drawAtRender = Canvas.batch []
    , swatches = initSwatches
    , palette = initPalette
    , horizontalToolbarHeight = 58
    , windowSize = { width = 0, height = 0 }
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
    , history = []
    , future = []
    , mousePosition = Nothing
    , selection = Nothing
    , clipboard = Nothing
    , taskbarDropped = Nothing
    , minimap = NoMinimap
    , menu = Nothing
    , seed = Random.initialSeed 0
    , config =
        { keyCmds = defaultKeyCmdConfig
        , quickKeys = defaultQuickKeys True
        , cmdKey =
            if True then
                .meta
            else
                .ctrl
        }
    }
        & Cmd.none
