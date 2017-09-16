module Main exposing (..)

import Html
import Json.Decode exposing (Value)
import Subscriptions exposing (subscriptions)
import Types exposing (Model, Msg(..), init)
import Update exposing (update)
import View exposing (view)


-- MAIN --


main : Program Value Model Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
