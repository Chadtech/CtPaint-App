module Types exposing (..)

import Array exposing (Array)
import Canvas exposing (Canvas, DrawOp(..), Point, Size)
import Color exposing (Color)
import ColorPicker
import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline as Pipeline
    exposing
        ( decode
        , required
        , requiredAt
        )
import Keyboard exposing (KeyCode)
import Keyboard.Extra exposing (Key(..))
import Menu
import Minimap
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
    , cmdKey =
        if isMac then
            .meta
        else
            .ctrl
    , keyConfig = defaultConfig
    , quickKeys = defaultQuickKeys isMac
    , taskbarDropped = Nothing
    , minimap = NoMinimap
    , menu = menu
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
    , minimap : MinimapState
    , menu : Maybe Menu.Model
    , seed : Seed
    }


type MinimapState
    = NoMinimap
    | Minimap Minimap.Model
    | Closed Position


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
    | KeyboardEvent (Result String KeyPayload)
    | DropDown (Maybe TaskbarDropDown)
    | HoverOnto TaskbarDropDown
    | Command Command
    | PaletteSquareClick Color
    | OpenColorPicker Color Int
    | OpenNewWindow NewWindow
    | AddPaletteSquare
    | InitImgur


type NewWindow
    = Preferences
    | Tutorial
    | Donate


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
    = SwatchesTurnLeft
    | SwatchesTurnRight
    | SwatchesQuickTurnLeft
    | RevertQuickTurnLeft
    | SwatchesQuickTurnRight
    | RevertQuickTurnRight
    | SwatchesQuickTurnDown
    | RevertQuickTurnDown
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
    | InitReplaceColor
    | ToggleColorPicker
    | SwitchGalleryView
    | ToggleMinimap
    | Delete
    | FlipHorizontal
    | FlipVertical
    | Rotate90
    | Rotate180
    | Rotate270
    | InvertColors
    | Save
    | NoCommand


type alias Swatches =
    { primary : Color
    , first : Color
    , second : Color
    , third : Color
    , keyIsDown : Bool
    }



-- WINDOW --


toUrl : NewWindow -> String
toUrl window =
    case window of
        Preferences ->
            "https://www.twitter.com"

        Tutorial ->
            "https://www.twitter.com"

        Donate ->
            "https://www.twitter.com"



-- PALETTE --


initPalette : Array Color
initPalette =
    [ Color.rgba 176 166 154 255
    , Color.black
    , Color.white
    , Color.rgba 101 92 74 255
    , Color.rgba 85 96 45 255
    , Color.rgba 172 214 48 255
    , Color.rgba 221 201 142 255
    , Color.rgba 243 210 21 255
    , Color.rgba 240 146 50 255
    , Color.rgba 255 91 49 255
    , Color.rgba 212 51 27 255
    , Color.rgba 242 29 35 255
    , Color.rgba 252 164 132 255
    , Color.rgba 230 121 166 255
    , Color.rgba 80 0 87 255
    , Color.rgba 240 224 214 255
    , Color.rgba 255 255 238 255
    , Color.rgba 157 144 136 255
    , Color.rgba 50 54 128 255
    , Color.rgba 36 33 157 255
    , Color.rgba 0 47 167 255
    , Color.rgba 23 92 254 255
    , Color.rgba 10 186 181 255
    , Color.rgba 159 170 210 255
    , Color.rgba 214 218 240 255
    , Color.rgba 238 242 255 255
    , Color.rgba 157 212 147 255
    , Color.rgba 170 211 13 255
    , Color.rgba 60 182 99 255
    , Color.rgba 10 202 26 255
    , Color.rgba 201 207 215 255
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
    [ ( Down, Number2, CmdIsUp, ShiftIsUp ) := SwatchesQuickTurnLeft
    , ( Down, Number3, CmdIsUp, ShiftIsUp ) := SwatchesQuickTurnDown
    , ( Down, Number4, CmdIsUp, ShiftIsUp ) := SwatchesQuickTurnRight
    , ( Down, Number1, CmdIsUp, ShiftIsUp ) := SwatchesTurnLeft
    , ( Up, Number2, CmdIsUp, ShiftIsUp ) := RevertQuickTurnLeft
    , ( Up, Number3, CmdIsUp, ShiftIsUp ) := RevertQuickTurnDown
    , ( Up, Number4, CmdIsUp, ShiftIsUp ) := RevertQuickTurnRight
    , ( Down, Number5, CmdIsUp, ShiftIsUp ) := SwatchesTurnRight
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
    , ( Down, BackQuote, CmdIsUp, ShiftIsUp ) := ToggleMinimap
    , ( Down, CharD, CmdIsUp, ShiftIsDown ) := InitDownload
    , ( Down, CharI, CmdIsDown, ShiftIsUp ) := InitImport
    , ( Down, CharD, CmdIsDown, ShiftIsDown ) := InitScale
    , ( Down, CharT, CmdIsUp, ShiftIsUp ) := InitText
    , ( Down, CharR, CmdIsUp, ShiftIsUp ) := InitReplaceColor
    , ( Down, Tab, CmdIsUp, ShiftIsUp ) := SwitchGalleryView
    , ( Down, BackSpace, CmdIsUp, ShiftIsUp ) := Delete
    , ( Down, CharE, CmdIsUp, ShiftIsUp ) := ToggleColorPicker
    , ( Down, CharH, CmdIsUp, ShiftIsDown ) := FlipHorizontal
    , ( Down, CharV, CmdIsUp, ShiftIsDown ) := FlipVertical
    , ( Down, CharR, CmdIsUp, ShiftIsDown ) := Rotate90
    , ( Down, CharF, CmdIsUp, ShiftIsDown ) := Rotate180
    , ( Down, CharE, CmdIsUp, ShiftIsDown ) := Rotate270
    , ( Down, CharI, CmdIsUp, ShiftIsDown ) := InvertColors
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


decodeCanvas : Value -> Result String Canvas
decodeCanvas json =
    json
        |> Decode.decodeValue canvasDecoder


canvasDecoder : Decoder Canvas
canvasDecoder =
    decode toCanvas
        |> requiredAt
            [ "canvas", "size", "width" ]
            Decode.int
        |> requiredAt
            [ "canvas", "size", "height" ]
            Decode.int
        |> requiredAt
            [ "canvas", "data" ]
            Decode.string


toCanvas : Int -> Int -> String -> Canvas
toCanvas width height data =
    let
        size =
            { width = width
            , height = height
            }

        colors =
            data
                |> String.toList
    in
    Canvas.initialize size
        |> fillBlack


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


decodeKeyPayload : Value -> Result String KeyPayload
decodeKeyPayload =
    Decode.decodeValue keyPayloadDecoder


keyPayloadDecoder : Decoder KeyPayload
keyPayloadDecoder =
    decode KeyPayload
        |> required "keyCode" Decode.int
        |> required "meta" Decode.bool
        |> required "ctrl" Decode.bool
        |> required "shift" Decode.bool
        |> required "direction" directionDecoder


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
