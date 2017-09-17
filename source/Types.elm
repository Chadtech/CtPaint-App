module Types exposing (..)

import Array exposing (Array)
import Canvas exposing (Canvas, DrawOp(..), Point, Size)
import Color exposing (Color)
import ColorPicker
import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)
import Keyboard exposing (KeyCode)
import Keyboard.Extra exposing (Key(..))
import List.Unique exposing (UniqueList)
import Menu exposing (Menu(..))
import Minimap.Types as Minimap
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Palette.Init
import Palette.Types as Palette exposing (Swatches)
import Random exposing (Seed)
import Taskbar.Types as Taskbar
import Time exposing (Time)
import Tool exposing (Tool(..))
import Util exposing ((:=), tbw)


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

        keyUpConfig : Dict String Command
        keyUpConfig =
            Dict.fromList []

        isMac : Bool
        isMac =
            decodeIsMac json

        --Keyboard.initKeyUp
        --    (decodeIsMac json)
        --    (decodeIsChrome json)
        --    Nothing
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
    , cmdKey =
        if isMac then
            .meta
        else
            .ctrl
    , keyboardUpConfig = keyUpConfig
    , keyboardUpLookUp = Dict.fromList []
    , keyboardDownConfig = defaultKeyDownConfig
    , keyboardDownLookUp = Dict.fromList []
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
    , cmdKey : KeyPayload -> Bool
    , keyboardUpConfig : Dict String Command
    , keyboardUpLookUp : Dict String (List String)
    , keyboardDownConfig : Dict String Command
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
    | ToolMsg Tool.Msg
    | TaskbarMsg Taskbar.Msg
    | MenuMsg Menu.Msg
    | Tick Time
    | ColorPickerMsg ColorPicker.Msg
    | MinimapMsg Minimap.Msg
    | ScreenMouseMove MouseEvent
    | ScreenMouseExit
    | HandleWindowFocus Bool
    | KeyboardEvent Direction Decode.Value


type alias KeyPayload =
    { code : KeyCode
    , meta : Bool
    , ctrl : Bool
    , shift : Bool
    }


type Direction
    = Up
    | Down


type alias Session =
    { email : String }


type HistoryOp
    = CanvasChange Canvas
    | ColorChange Int Color


type Command
    = SwatchesOneTurn
    | SwatchesThreeTurns
    | SwatchesTwoTurns
    | SetToolToPencil
    | SetToolToHand
    | SetToolToSelect
    | SetToolToFill
    | Undo
    | Redo
    | Cut
    | Copy
    | SelectAll
    | Paste
    | ZoomIn
    | ZoomOut
    | ShowMinimap
    | Download
    | Import
    | Scale
    | SwitchGalleryView
    | NoCommand



-- KEYBOARD --


payloadToString : (KeyPayload -> Bool) -> KeyPayload -> String
payloadToString cmdKey payload =
    let
        code =
            toString payload.code

        shift =
            toString payload.shift

        cmd =
            toString (cmdKey payload)
    in
    shift ++ cmd ++ code


type CmdState
    = CmdIsDown
    | CmdIsUp


type ShiftState
    = ShiftIsDown
    | ShiftIsUp


type alias QuickKey =
    ( Direction, Key, CmdState, ShiftState )


defaultConfig : List ( QuickKey, Command )
defaultConfig =
    [ ( Down, Number2, CmdIsUp, ShiftIsUp ) := SwatchesOneTurn
    , ( Down, Number3, CmdIsUp, ShiftIsUp ) := SwatchesTwoTurns
    , ( Down, Number4, CmdIsUp, ShiftIsUp ) := SwatchesThreeTurns
    , ( Up, Number1, CmdIsUp, ShiftIsUp ) := SwatchesOneTurn
    , ( Up, Number2, CmdIsUp, ShiftIsUp ) := SwatchesThreeTurns
    , ( Up, Number3, CmdIsUp, ShiftIsUp ) := SwatchesTwoTurns
    , ( Up, Number4, CmdIsUp, ShiftIsUp ) := SwatchesThreeTurns
    , ( Up, CharP, CmdIsUp, ShiftIsUp ) := SetToolToPencil
    , ( Up, CharH, CmdIsUp, ShiftIsUp ) := SetToolToHand
    , ( Up, CharS, CmdIsUp, ShiftIsUp ) := SetToolToSelect
    , ( Up, CharG, CmdIsUp, ShiftIsUp ) := SetToolToFill
    , ( Up, CharZ, CmdIsDown, ShiftIsUp ) := Undo
    , ( Up, CharY, CmdIsDown, ShiftIsUp ) := Redo
    , ( Up, CharC, CmdIsDown, ShiftIsUp ) := Copy
    , ( Up, CharX, CmdIsDown, ShiftIsUp ) := Cut
    , ( Up, CharV, CmdIsDown, ShiftIsUp ) := Paste
    , ( Up, CharA, CmdIsDown, ShiftIsUp ) := SelectAll
    , ( Up, Equals, CmdIsUp, ShiftIsUp ) := ZoomIn
    , ( Up, Minus, CmdIsUp, ShiftIsUp ) := ZoomOut
    , ( Up, BackQuote, CmdIsUp, ShiftIsUp ) := ShowMinimap
    , ( Up, CharD, CmdIsUp, ShiftIsDown ) := Download
    , ( Up, CharI, CmdIsDown, ShiftIsUp ) := Import
    , ( Up, CharD, CmdIsDown, ShiftIsDown ) := Scale
    , ( Up, Tab, CmdIsUp, ShiftIsUp ) := SwitchGalleryView
    ]


defaultKeyDownConfig : Dict String Command
defaultKeyDownConfig =
    defaultConfig
        |> List.filter (Tuple.first >> directionIsDown)
        |> List.map (Tuple.mapFirst quickKeyToString)
        |> Dict.fromList


quickKeyToString : QuickKey -> String
quickKeyToString ( _, key, cmd, shift ) =
    let
        code =
            Keyboard.Extra.toCode key
                |> toString

        cmdStr =
            cmd
                == CmdIsDown
                |> toString

        shiftStr =
            shift
                == ShiftIsDown
                |> toString
    in
    shiftStr ++ cmdStr ++ code


directionIsDown : QuickKey -> Bool
directionIsDown ( direction, _, _, _ ) =
    direction == Down



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



-- KEYPAYLOARD DECODER


keyPayloadDecoder : Decoder KeyPayload
keyPayloadDecoder =
    decode KeyPayload
        |> required "keyCode" Decode.int
        |> required "cmd" Decode.bool
        |> required "ctrl" Decode.bool
        |> required "shift" Decode.bool



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
