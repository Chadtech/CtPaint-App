module Keyboard.Types exposing (..)

import Keyboard exposing (KeyCode)


type Direction
    = Up KeyCode


type Message
    = KeyEvent Direction
