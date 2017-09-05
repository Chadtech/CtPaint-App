module Main exposing (..)

import Html
import Json.Decode exposing (Value)
import Main.Init exposing (init)
import Main.Message exposing (Message(..))
import Main.Model exposing (Model)
import Main.Subscriptions exposing (subscriptions)
import Main.Update exposing (update)
import Main.View exposing (view)


-- MAIN --


main : Program Value Model Message
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
