module PaintApp exposing (getTrackingCmd, main, subscriptions, update, view)

import Error
import Html exposing (Html)
import Init exposing (init)
import Json.Decode as Decode exposing (Decoder, Value, value)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Ports
import Return2 as R2
import Subscriptions
import Track exposing (track)
import Update
import View



-- MAIN --


main : Program Value (Result Init.Error Model) Msg
main =
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
        |> Html.programWithFlags



-- VIEW --


view : Result Init.Error Model -> Html Msg
view result =
    case result of
        Ok model ->
            View.view model

        Err Init.AllowanceExceeded ->
            Html.text ""

        Err (Init.Other err) ->
            Error.view err



-- UPDATE --


update : Msg -> Result Init.Error Model -> ( Result Init.Error Model, Cmd Msg )
update msg result =
    case result of
        Ok model ->
            Update.update msg model
                |> Tuple.mapFirst Ok
                |> R2.addCmd (getTrackingCmd msg model)

        Err err ->
            Err err
                |> R2.withNoCmd


getTrackingCmd : Msg -> Model -> Cmd Msg
getTrackingCmd msg model =
    model
        |> track msg
        |> Ports.sendTracking
            model.config
            model.user



-- SUBSCRIPTIONS --


subscriptions : Result Init.Error Model -> Sub Msg
subscriptions result =
    case result of
        Ok model ->
            Subscriptions.subscriptions model

        Err _ ->
            Sub.none
