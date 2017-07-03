module Main exposing (..)

import Html
import Main.Model exposing (Model)
import Main.Message exposing (Message(..))
import Main.View exposing (view)
import Main.Update exposing (update)
import Main.Subscriptions exposing (subscriptions)


-- MAIN --


main : Program Never Model Message
main =
    Html.program
        { init = ( Model Nothing, Cmd.none )
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
