port module Ports exposing (..)


port windowFocus : (Bool -> msg) -> Sub msg


port stealFocus : () -> Cmd msg


port returnFocus : () -> Cmd msg
