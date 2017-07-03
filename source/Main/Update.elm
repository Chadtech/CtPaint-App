module Main.Update exposing (update)

import Main.Message exposing (Message(..))
import Main.Model exposing (Model)


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    model ! []
