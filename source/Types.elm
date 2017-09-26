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
import Menu
import Minimap.Types as Minimap
import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)
import Random exposing (Seed)
import Time exposing (Time)
import Tool exposing (Tool(..))
import Util exposing ((&), (:=), tbw)


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
    , swatches = initSwatches
    , palette = initPalette
    , horizontalToolbarHeight = 58
    , windowSize = windowSize
    , tool = Tool.init
    , zoom = 1
    , galleryView = False
    , colorPicker = ColorPicker.init initPalette
    , history = [ CanvasChange canvas ]
    , future = []
    , mousePosition = Nothing
    , selection = Nothing
    , clipboard = Nothing
    , cmdKey =
        if isMac then
            .meta
        else
            .ctrl
    , keyConfig = defaultConfig
    , quickKeys = defaultQuickKeys isMac
    , taskbarDropped = Nothing
    , minimap = Nothing
    , menu = Nothing
    , seed = Random.initialSeed (decodeSeed json)
    }
        & Cmd.none



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
    , cmdKey : KeyPayload -> Bool
    , keyConfig : Dict String Command
    , quickKeys : Dict String String
    , taskbarDropped : Maybe TaskbarDropDown
    , minimap : Maybe Minimap.Model
    , menu : Maybe Menu.Model
    , seed : Seed
    }


type Msg
    = GetWindowSize Size
    | SetTool Tool
    | ToolMsg Tool.Msg
    | MenuMsg Menu.Msg
    | Tick Time
    | ColorPickerMsg ColorPicker.Msg
    | MinimapMsg Minimap.Msg
    | ScreenMouseMove MouseEvent
    | ScreenMouseExit
    | KeyboardEvent Decode.Value
    | DropDown (Maybe TaskbarDropDown)
    | HoverOnto TaskbarDropDown
    | Command Command
    | PaletteSquareClick Color
    | SetColorPicker Color Int
    | NoOp


type alias KeyPayload =
    { code : KeyCode
    , meta : Bool
    , ctrl : Bool
    , shift : Bool
    , direction : Direction
    }


type TaskbarDropDown
    = File
    | Edit
    | Transform
    | Tools
    | View
    | Help


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
    | SetToolToSample
    | SetToolToLine
    | SetToolToRectangle
    | SetToolToRectangleFilled
    | Undo
    | Redo
    | Cut
    | Copy
    | SelectAll
    | Paste
    | ZoomIn
    | ZoomOut
    | InitDownload
    | InitImport
    | InitScale
    | InitText
    | InitAbout
    | ToggleColorPicker
    | SwitchGalleryView
    | HideMinimap
    | ShowMinimap
    | NoCommand


type alias Swatches =
    { primary : Color
    , first : Color
    , second : Color
    , third : Color
    , keyIsDown : Bool
    }



-- PALETTE --


initPalette : Array Color
initPalette =
    [ Color.rgba 176 166 154 255
    , Color.black
    , Color.white
    , Color.rgba 241 29 35 255
    , Color.black
    , Color.black
    , Color.black
    , Color.black
    ]
        |> Array.fromList


initSwatches : Swatches
initSwatches =
    { primary = Color.rgba 176 166 154 255
    , first = Color.black
    , second = Color.white
    , third = Color.rgba 241 29 35 255
    , keyIsDown = False
    }



-- KEYBOARD --


payloadToString : (KeyPayload -> Bool) -> KeyPayload -> String
payloadToString cmdKey payload =
    let
        direction =
            toString payload.direction

        code =
            toString payload.code

        shift =
            toString payload.shift

        cmd =
            toString (cmdKey payload)
    in
    shift ++ cmd ++ code ++ direction


type CmdState
    = CmdIsDown
    | CmdIsUp


type ShiftState
    = ShiftIsDown
    | ShiftIsUp


type alias QuickKey =
    ( Direction, Key, CmdState, ShiftState )


defaultConfigBase : List ( QuickKey, Command )
defaultConfigBase =
    [ ( Down, Number2, CmdIsUp, ShiftIsUp ) := SwatchesOneTurn
    , ( Down, Number3, CmdIsUp, ShiftIsUp ) := SwatchesTwoTurns
    , ( Down, Number4, CmdIsUp, ShiftIsUp ) := SwatchesThreeTurns
    , ( Up, Number1, CmdIsUp, ShiftIsUp ) := SwatchesOneTurn
    , ( Down, Number2, CmdIsUp, ShiftIsUp ) := SwatchesThreeTurns
    , ( Down, Number3, CmdIsUp, ShiftIsUp ) := SwatchesTwoTurns
    , ( Down, Number4, CmdIsUp, ShiftIsUp ) := SwatchesThreeTurns
    , ( Up, Number5, CmdIsUp, ShiftIsUp ) := SwatchesOneTurn
    , ( Down, CharP, CmdIsUp, ShiftIsUp ) := SetToolToPencil
    , ( Down, CharH, CmdIsUp, ShiftIsUp ) := SetToolToHand
    , ( Down, CharS, CmdIsUp, ShiftIsUp ) := SetToolToSelect
    , ( Down, CharG, CmdIsUp, ShiftIsUp ) := SetToolToFill
    , ( Down, CharI, CmdIsUp, ShiftIsUp ) := SetToolToSample
    , ( Down, CharL, CmdIsUp, ShiftIsUp ) := SetToolToLine
    , ( Down, CharU, CmdIsUp, ShiftIsUp ) := SetToolToRectangle
    , ( Down, CharJ, CmdIsUp, ShiftIsUp ) := SetToolToRectangleFilled
    , ( Down, CharZ, CmdIsDown, ShiftIsUp ) := Undo
    , ( Down, CharY, CmdIsDown, ShiftIsUp ) := Redo
    , ( Down, CharC, CmdIsDown, ShiftIsUp ) := Copy
    , ( Down, CharX, CmdIsDown, ShiftIsUp ) := Cut
    , ( Down, CharV, CmdIsDown, ShiftIsUp ) := Paste
    , ( Down, CharA, CmdIsDown, ShiftIsUp ) := SelectAll
    , ( Down, Equals, CmdIsUp, ShiftIsUp ) := ZoomIn
    , ( Down, Minus, CmdIsUp, ShiftIsUp ) := ZoomOut
    , ( Down, BackQuote, CmdIsUp, ShiftIsUp ) := ShowMinimap
    , ( Down, CharD, CmdIsUp, ShiftIsDown ) := InitDownload
    , ( Down, CharI, CmdIsDown, ShiftIsUp ) := InitImport
    , ( Down, CharD, CmdIsDown, ShiftIsDown ) := InitScale
    , ( Down, CharT, CmdIsUp, ShiftIsUp ) := InitText
    , ( Down, Tab, CmdIsUp, ShiftIsUp ) := SwitchGalleryView
    ]


defaultConfig : Dict String Command
defaultConfig =
    defaultConfigBase
        |> List.map (Tuple.mapFirst quickKeyToString)
        |> Dict.fromList


defaultQuickKeys : Bool -> Dict String String
defaultQuickKeys isMac =
    defaultConfigBase
        |> List.map (quickKeyLookUp isMac)
        |> Dict.fromList


quickKeyLookUp : Bool -> ( QuickKey, Command ) -> ( String, String )
quickKeyLookUp isMac ( ( _, key, cmdKey, shift ), command ) =
    let
        commandStr =
            toString command

        cmdKeyStr =
            case ( cmdKey, isMac ) of
                ( CmdIsDown, True ) ->
                    "Cmd + "

                ( CmdIsDown, False ) ->
                    "Ctrl + "

                _ ->
                    ""

        shiftStr =
            if shift == ShiftIsDown then
                "Shift + "
            else
                ""

        keyStr =
            keyCodeToString (Keyboard.Extra.toCode key)
    in
    ( commandStr, cmdKeyStr ++ shiftStr ++ keyStr )


quickKeyToString : QuickKey -> String
quickKeyToString ( direction, key, cmd, shift ) =
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
    shiftStr ++ cmdStr ++ code ++ toString direction


directionIsDown : QuickKey -> Bool
directionIsDown ( direction, _, _, _ ) =
    direction == Down


directionIsUp : QuickKey -> Bool
directionIsUp ( direction, _, _, _ ) =
    direction == Up


keyCodeToString : KeyCode -> String
keyCodeToString key =
    case Keyboard.Extra.fromCode key of
        Control ->
            "Ctrl"

        QuestionMark ->
            "?"

        Equals ->
            "="

        Minus ->
            "-"

        Semicolon ->
            ";"

        Super ->
            "Cmd"

        Asterisk ->
            "*"

        Comma ->
            ","

        Dollar ->
            "$"

        BackQuote ->
            "`"

        other ->
            let
                otherAsStr =
                    toString other

                isChar =
                    String.left 4 otherAsStr == "Char"

                isNumber =
                    String.left 6 otherAsStr == "Number"
            in
            case ( isChar, isNumber ) of
                ( True, _ ) ->
                    String.right 1 otherAsStr

                ( _, True ) ->
                    String.right 1 otherAsStr

                _ ->
                    otherAsStr



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



-- KEYPAYLOAD DECODER


keyPayloadDecoder : Decoder KeyPayload
keyPayloadDecoder =
    decode KeyPayload
        |> required "keyCode" Decode.int
        |> required "meta" Decode.bool
        |> required "ctrl" Decode.bool
        |> required "shift" Decode.bool
        |> required "direction" (Decode.succeed Down)


directionDecoder : Decoder Direction
directionDecoder =
    Decode.string
        |> Decode.andThen handleDirectionString


handleDirectionString : String -> Decoder Direction
handleDirectionString dir =
    case dir of
        "up" ->
            Decode.succeed Up

        "down" ->
            Decode.succeed Down

        _ ->
            Decode.fail "Direction not up or down"



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
