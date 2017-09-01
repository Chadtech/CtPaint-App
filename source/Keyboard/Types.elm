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
    | NoCommand


type alias Config =
    Dict (List KeyCode) QuickKey


defaultKeyDownConfig : Config
defaultKeyDownConfig =
    [ [ Number2 ] := SwatchesOneTurn
    , [ Number3 ] := SwatchesTwoTurns
    , [ Number4 ] := SwatchesThreeTurns
    ]
        |> List.map keysToCodes
        |> Dict.fromList


defaultKeyUpConfig : Config
defaultKeyUpConfig =
    [ [ Number1 ] := SwatchesOneTurn
    , [ Number2 ] := SwatchesThreeTurns
    , [ Number3 ] := SwatchesTwoTurns
    , [ Number4 ] := SwatchesOneTurn
    , [ Number5 ] := SwatchesThreeTurns
    , [ CharP ] := SetToolToPencil
    , [ CharH ] := SetToolToHand
    , [ CharS ] := SetToolToSelect
    , [ Control, CharZ ] := Undo
    , [ Control, CharY ] := Redo
    , [ Equals ] := ZoomIn
    , [ Minus ] := ZoomOut
    ]
        |> List.map keysToCodes
        -- ff and chrome have different codes for equals
        |>
            (::) ([ 187 ] := ZoomIn)
        |> Dict.fromList


keysToCodes : ( List Key, QuickKey ) -> ( List KeyCode, QuickKey )
keysToCodes ( keys, cmds ) =
    ( List.map Keyboard.Extra.toCode keys, cmds )
