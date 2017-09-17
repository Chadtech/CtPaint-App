module Types exposing (..)

import Array exposing (Array)
import Canvas exposing (Canvas, DrawOp(..), Point, Size)
import Color exposing (Color)
import ColorPicker.Types as ColorPicker
import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder, Value)
import Keyboard exposing (KeyCode)
import Keyboard.Types as Keyboard exposing (Config)
import List.Unique exposing (UniqueList)
import Menu.Types as Menu exposing (Menu(..))
import Minimap.Types as Minimap
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Palette.Init
import Palette.Types as Palette exposing (Swatches)
import Random exposing (Seed)
import Taskbar.Types as Taskbar
import Time exposing (Time)
import Tool exposing (Tool(..))
import Util exposing (tbw)


-- INIT --


init : Value -> ( Model, Cmd Msg )
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
    { session = decodeSession json
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

    --, subMouseMove = Nothing
    , windowSize = windowSize
    , tool = Tool.init
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



-- TYPES --


type alias Model =
    { session : Maybe Session
    , canvas : Canvas
    , projectName : Maybe String
    , canvasPosition : Position
    , pendingDraw : DrawOp
    , drawAtRender : DrawOp
    , swatches : Swatches
    , palette : Array Color
    , horizontalToolbarHeight : Int

    --, subMouseMove : Maybe (Position -> Msg)
    , windowSize : Size
    , tool : Tool
    , zoom : Int
    , galleryView : Bool
    , colorPicker : ColorPicker.Model
    , history : List HistoryOp
    , future : List HistoryOp
    , mousePosition : Maybe Position
    , selection : Maybe ( Position, Canvas )
    , clipboard : Maybe ( Position, Canvas )
    , keysDown : UniqueList KeyCode
    , keyboardUpConfig : Keyboard.Config
    , keyboardUpLookUp : Dict String (List String)
    , keyboardDownConfig : Keyboard.Config
    , keyboardDownLookUp : Dict String (List String)
    , taskbarDropped : Maybe Taskbar.Option
    , minimap : Maybe Minimap.Model
    , menu : Menu
    , seed : Seed
    }


type Msg
    = PaletteMsg Palette.Msg
    | GetWindowSize Size
    | SetTool Tool
    | KeyboardMsg Keyboard.Msg
    | ToolMsg Tool.Msg
    | TaskbarMsg Taskbar.Msg
    | MenuMsg Menu.Msg
    | Tick Time
    | ColorPickerMsg ColorPicker.Msg
    | MinimapMsg Minimap.Msg
    | ScreenMouseMove MouseEvent
    | ScreenMouseExit
    | HandleWindowFocus Bool


type Direction
    = Up
    | Down


type alias Session =
    { email : String }


type HistoryOp
    = CanvasChange Canvas
    | ColorChange Int Color



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


sessionDecoder : Decoder Session
sessionDecoder =
    Decode.field "email" Decode.string
        |> Decode.map Session


decodeSession : Value -> Maybe Session
decodeSession =
    Decode.decodeValue sessionDecoder >> Result.toMaybe
