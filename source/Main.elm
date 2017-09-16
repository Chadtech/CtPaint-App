module Main exposing (..)

--import Init exposing (init)

import Html
import Json.Decode exposing (Value)
import Model exposing (Model, init)
import Msg exposing (Msg(..))
import Subscriptions exposing (subscriptions)
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
