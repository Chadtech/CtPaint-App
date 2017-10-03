module Imgur exposing (..)

import Html exposing (Html)


-- TYPES --


type Model
    = Loading
    | Url String
    | Fail


type Msg
    = ReceiveUrl String



-- VIEW --


view : Model -> List (Html Msg)
view model =
    []



-- INIT --


init : Model
init =
    Loading
