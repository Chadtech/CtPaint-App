module Main.Message exposing (Message(..))

import Window exposing (Size)


type Message
    = GetWindowSize (Result String Size)
