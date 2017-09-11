module Keyboard.Types exposing (..)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)
import Keyboard exposing (KeyCode)
import Keyboard.Extra exposing (Key(..))
import Util exposing ((:=))


type Direction
    = Up Decode.Value
    | Down Decode.Value


type Message
    = KeyEvent Direction


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


type alias Config =
    Dict (List KeyCode) Command


type alias KeyPayload =
    { code : Int
    , cmd : Bool
    , ctrl : Bool
    , shift : Bool
    }


keyPayloadDecoder : Decoder KeyPayload
keyPayloadDecoder =
    decode KeyPayload
        |> required "keyCode" Decode.int
        |> required "cmd" Decode.bool
        |> required "ctrl" Decode.bool
        |> required "shift" Decode.bool



-- KEY DOWN CONFIG --


defaultKeyDownConfig : Config
defaultKeyDownConfig =
    [ [ Number2 ] := SwatchesOneTurn
    , [ Number3 ] := SwatchesTwoTurns
    , [ Number4 ] := SwatchesThreeTurns
    ]
        |> List.map keysToCodes
        |> Dict.fromList



-- KEY UP CONFIG --


initKeyUp : Bool -> Bool -> Maybe (Key -> Config) -> Config
initKeyUp isMac isChrome customConfig =
    let
        cmdKey =
            if isMac then
                Super
            else
                Control
    in
    case customConfig of
        Nothing ->
            defaultKeyUpConfig cmdKey

        Just config ->
            config cmdKey


defaultKeyUpConfig : Key -> Config
defaultKeyUpConfig cmd =
    [ [ Number1 ] := SwatchesOneTurn
    , [ Number2 ] := SwatchesThreeTurns
    , [ Number3 ] := SwatchesTwoTurns
    , [ Number4 ] := SwatchesOneTurn
    , [ Number5 ] := SwatchesThreeTurns
    , [ CharP ] := SetToolToPencil
    , [ CharH ] := SetToolToHand
    , [ CharS ] := SetToolToSelect
    , [ CharG ] := SetToolToFill
    , [ CharZ, cmd ] := Undo
    , [ CharY, cmd ] := Redo
    , [ CharC, cmd ] := Copy
    , [ CharX, cmd ] := Cut
    , [ CharV, cmd ] := Paste
    , [ CharA, cmd ] := SelectAll
    , [ Equals ] := ZoomIn
    , [ Minus ] := ZoomOut
    , [ BackQuote ] := ShowMinimap
    , [ CharD, Shift ] := Download
    , [ CharI, cmd ] := Import
    , [ CharD, Shift, cmd ] := Scale
    , [ Tab ] := SwitchGalleryView
    ]
        |> List.map keysToCodes
        -- ff and chrome have different codes for equals
        |> (::) ([ 187 ] := ZoomIn)
        |> Dict.fromList


keysToCodes : ( List Key, Command ) -> ( List KeyCode, Command )
keysToCodes ( keys, cmds ) =
    ( List.map Keyboard.Extra.toCode keys, cmds )



-- REVERSE CONFIG --


reverseConfig : Config -> Dict String (List String)
reverseConfig =
    Dict.toList
        >> List.map pairToStrings
        >> Dict.fromList


swap : ( a, b ) -> ( b, a )
swap ( a, b ) =
    ( b, a )


pairToStrings : ( List Int, Command ) -> ( String, List String )
pairToStrings =
    swap
        >> Tuple.mapFirst toString
        >> Tuple.mapSecond (List.map keyToString >> List.reverse)


keyToString : KeyCode -> String
keyToString key =
    case Keyboard.Extra.fromCode key of
        Control ->
            "Ctrl"

        QuestionMark ->
            "?"

        Equals ->
            "="

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
