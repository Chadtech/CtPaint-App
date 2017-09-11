port module Keyboard.Subscriptions exposing (..)

import Json.Decode exposing (Value)


port keyDown : (Value -> msg) -> Sub msg


port keyUp : (Value -> msg) -> Sub msg
