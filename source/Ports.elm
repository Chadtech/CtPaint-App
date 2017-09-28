port module Ports exposing (..)


port stealFocus : () -> Cmd msg


port returnFocus : () -> Cmd msg


port openNewPage : String -> Cmd msg
