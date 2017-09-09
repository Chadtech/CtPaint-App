module Main.Init exposing (..)

import Canvas exposing (Canvas, DrawOp(..), Point, Size)
import Color
import ColorPicker.Types as ColorPicker
import History.Types exposing (HistoryOp(..))
import Json.Decode as Decode exposing (Decoder, Value)
import Keyboard.Types as Keyboard exposing (Config)
import List.Unique
import Main.Message exposing (Message(..))
import Main.Model exposing (Model)
import Menu.Types exposing (Menu(..))
import Palette.Init
import Random
import Tool.Types exposing (Tool(..))
import Types.Session as Session
import Util exposing (tbw)


init : Value -> ( Model, Cmd Message )
init json =
    let
        windowSize : Size
        windowSize =
            decodeWindow json

        canvas : Canvas
        canvas =
            Size 400 400
                |> Canvas.initialize
                |> fillBlack

        canvasSize : Size
        canvasSize =
            Canvas.getSize canvas

        keyUpConfig : Config
        keyUpConfig =
            Keyboard.initKeyUp
                (decodeIsMac json)
                (decodeIsChrome json)
                Nothing
    in
    { session = Session.decode json
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
    , swatches = Palette.Init.swatches
    , palette = Palette.Init.palette
    , horizontalToolbarHeight = 58
    , subMouseMove = Nothing
    , windowSize = windowSize
    , tool = Hand Nothing
    , zoom = 1
    , galleryView = False
    , colorPicker = ColorPicker.init Palette.Init.palette
    , history = [ CanvasChange canvas ]
    , future = []
    , mousePosition = Nothing
    , selection = Nothing
    , clipboard = Nothing
    , keysDown = List.Unique.empty
    , keyboardUpConfig = keyUpConfig
    , keyboardUpLookUp = Keyboard.reverseConfig keyUpConfig
    , keyboardDownConfig = Keyboard.defaultKeyDownConfig
    , keyboardDownLookUp =
        Keyboard.reverseConfig
            Keyboard.defaultKeyDownConfig
    , taskbarDropped = Nothing
    , minimap = Nothing
    , menu = None
    , seed = Random.initialSeed (decodeSeed json)
    }
        ! []



-- INIT CANVAS --


fillBlack : Canvas -> Canvas
fillBlack canvas =
    Canvas.draw (fillBlackOp canvas) canvas


fillBlackOp : Canvas -> DrawOp
fillBlackOp canvas =
    [ BeginPath
    , Rect (Point 0 0) (Canvas.getSize canvas)
    , FillStyle Color.black
    , Canvas.Fill
    ]
        |> Canvas.batch



-- PLATFORM DECODERS --


decodeIsChrome : Value -> Bool
decodeIsChrome json =
    case Decode.decodeValue isChromeDecoder json of
        Ok isChrome ->
            isChrome

        Err _ ->
            True


isChromeDecoder : Decoder Bool
isChromeDecoder =
    Decode.field "isChrome" Decode.bool


decodeIsMac : Value -> Bool
decodeIsMac json =
    case Decode.decodeValue isMacDecoder json of
        Ok isMac ->
            isMac

        Err _ ->
            False


isMacDecoder : Decoder Bool
isMacDecoder =
    Decode.field "isMac" Decode.bool



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



-- WINDOW SIZE DECODER --


decodeWindow : Value -> Size
decodeWindow json =
    case Decode.decodeValue windowDecoder json of
        Ok ( w, h ) ->
            Size w h

        Err _ ->
            Size 800 800


windowDecoder : Decoder ( Int, Int )
windowDecoder =
    Decode.map2 (,)
        (Decode.field "windowWidth" Decode.int)
        (Decode.field "windowHeight" Decode.int)
