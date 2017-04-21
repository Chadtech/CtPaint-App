module Main.Subscriptions exposing (subscriptions)

import Main.Model exposing (Model)
import Main.Message exposing (Msg(..))
import Ports exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
