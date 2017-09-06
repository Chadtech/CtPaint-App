module Keyboard.Types exposing (..)

import Dict exposing (Dict)
import Keyboard exposing (KeyCode)
import Keyboard.Extra exposing (Key(..))
import Util exposing ((:=))


type Direction
    = Up KeyCode
    | Down KeyCode


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
    | Paste
    | ZoomIn
    | ZoomOut
    | ShowMinimap
    | Download
    | Import
    | NoCommand


type alias Config =
    Dict (List KeyCode) Command



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
    , [ Equals ] := ZoomIn
    , [ Minus ] := ZoomOut
    , [ BackQuote ] := ShowMinimap
    , [ CharD, Shift ] := Download
    , [ CharI, cmd ] := Import
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
