module Data.Keys
    exposing
        ( KeyCmd(..)
        , KeyEvent
        , QuickKey
        , decodeKeyEvent
        , defaultKeyCmdConfig
        , defaultQuickKeys
        )

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline
    exposing
        ( decode
        , required
        )
import Keyboard exposing (KeyCode)
import Keyboard.Extra exposing (Key(..))
import Tuple.Infix exposing ((:=))


-- TYPES --


type alias KeyEvent =
    { code : KeyCode
    , meta : Bool
    , ctrl : Bool
    , shift : Bool
    , direction : Direction
    }


type Direction
    = Up
    | Down


type KeyCmd
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
    | InitImgur
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
    | NoCmd


type CmdState
    = CmdIsDown
    | CmdIsUp


type ShiftState
    = ShiftIsDown
    | ShiftIsUp


type alias QuickKey =
    ( Direction, Key, CmdState, ShiftState )


defaultConfigBase : List ( QuickKey, KeyCmd )
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


defaultKeyCmdConfig : Dict String KeyCmd
defaultKeyCmdConfig =
    defaultConfigBase
        |> List.map (Tuple.mapFirst quickKeyToString)
        |> Dict.fromList


defaultQuickKeys : Bool -> Dict String String
defaultQuickKeys isMac =
    defaultConfigBase
        |> List.map (quickKeyLookUp isMac)
        |> Dict.fromList


quickKeyLookUp : Bool -> ( QuickKey, KeyCmd ) -> ( String, String )
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



-- KEYPAYLOAD DECODER


decodeKeyEvent : Value -> Result String KeyEvent
decodeKeyEvent =
    Decode.decodeValue keyEventDecoder


keyEventDecoder : Decoder KeyEvent
keyEventDecoder =
    decode KeyEvent
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
