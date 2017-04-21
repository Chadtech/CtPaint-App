module Main.View exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, onInput, keyCode)
import Main.Model exposing (Model)
import Main.Message exposing (Msg(..))


-- VIEW


view : Model -> Html Msg
view model =
    div
        [ class "main" ]
        [ title
        ]



-- COMPONENTS


title : Html Msg
title =
    words "Admin Panel"


words : String -> Html Msg
words str =
    node "words" [] [ text str ]
