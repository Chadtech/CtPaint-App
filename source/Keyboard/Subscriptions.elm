port module Keyboard.Subscriptions exposing (..)


port keyDown : (Int -> msg) -> Sub msg


port keyUp : (Int -> msg) -> Sub msg
