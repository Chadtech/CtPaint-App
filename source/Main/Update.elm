module Main.Update exposing (update)

import Main.Message exposing (Msg(..))
import Main.Model exposing (Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        NoOp ->
            ( model, Cmd.none )
