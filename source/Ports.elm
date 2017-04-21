port module Ports exposing (..)


port toJS : String -> Cmd msg


port fromJS : (String -> msg) -> Sub msg
