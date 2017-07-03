module Main exposing (..)

import Html
import Main.Model exposing (Model)
import Main.Message exposing (Message(..))
import Main.View exposing (view)
import Main.Update exposing (update)
import Main.Subscriptions exposing (subscriptions)
import Main.Init exposing (init)
import Json.Decode exposing (Value)


-- MAIN --


main : Program Value Model Message
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
