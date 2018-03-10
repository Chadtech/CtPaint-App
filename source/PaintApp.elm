module PaintApp exposing (..)

import Error
import Html exposing (Html)
import Init exposing (init)
import Json.Decode as Decode exposing (Decoder, Value, value)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Subscriptions exposing (subscriptions)
import Tuple.Infix exposing ((&), (|&))
import Update
import View


-- MAIN --


main : Program Value (Result String Model) Msg
main =
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
        |> Html.programWithFlags



-- VIEW --


view : Result String Model -> Html Msg
view result =
    case result of
        Ok model ->
            View.view model

        Err err ->
            Error.view err



-- UPDATE --


update : Msg -> Result String Model -> ( Result String Model, Cmd Msg )
update msg result =
    case result of
        Ok model ->
            Update.update msg model
                |> Tuple.mapFirst Ok

        Err err ->
            Err err & Cmd.none
