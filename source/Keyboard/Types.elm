module Keyboard.Types exposing (..)

import Keyboard exposing (KeyCode)
import Keyboard.Extra exposing (Key(..))
import Dict exposing (Dict)
import Util exposing ((:=))


type Direction
    = Up KeyCode
    | Down KeyCode


type Message
    = KeyEvent Direction


type QuickKey
    = SwatchesOneTurn
    | SwatchesThreeTurns
    | SwatchesTwoTurns
    | SetToolToPencil
    | SetToolToHand
    | SetToolToSelect
    | Undo
    | Redo
    | ZoomIn
    | ZoomOut


type alias Config =
    Dict (List KeyCode) QuickKey


defaultKeyDownConfig : Config
defaultKeyDownConfig =
    [ [ Number1 ] := SwatchesOneTurn
    , [ Number2 ] := SwatchesTwoTurns
    , [ Number3 ] := SwatchesThreeTurns
    ]
        |> List.map keysToCodes
        |> Dict.fromList


defaultKeyUpConfig : Config
defaultKeyUpConfig =
    [ [ Number1 ] := SwatchesThreeTurns
    , [ Number2 ] := SwatchesTwoTurns
    , [ Number3 ] := SwatchesOneTurn
    , [ CharP ] := SetToolToPencil
    , [ CharH ] := SetToolToHand
    , [ CharS ] := SetToolToSelect
    , [ Control, CharZ ] := Undo
    , [ Control, CharY ] := Redo
    , [ Super, Equals ] := ZoomIn
    , [ Super, Minus ] := ZoomOut
    ]
        |> List.map keysToCodes
        |> Dict.fromList


keysToCodes : ( List Key, QuickKey ) -> ( List KeyCode, QuickKey )
keysToCodes ( keys, cmds ) =
    ( List.map Keyboard.Extra.toCode keys, cmds )
