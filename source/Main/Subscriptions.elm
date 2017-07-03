module Main.Subscriptions exposing (subscriptions)

import Main.Model exposing (Model)
import Main.Message exposing (Message(..))


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.none
