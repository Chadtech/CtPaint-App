module Keyboard.Types exposing (..)

import Keyboard exposing (KeyCode)


type Direction
    = Up KeyCode
    | Down KeyCode


type Message
    = KeyEvent Direction
