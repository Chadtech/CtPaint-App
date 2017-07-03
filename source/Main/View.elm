module Main.View exposing (view)

import Html exposing (Html, div, p, text)
import Html.Attributes exposing (class)
import Main.Model exposing (Model)
import Main.Message exposing (Message(..))


-- VIEW --


view : Model -> Html Message
view model =
    div
        [ class "main" ]
        [ p [] [ text "Admin Panel" ]
        ]
