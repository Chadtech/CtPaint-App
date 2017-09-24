module Text exposing (..)

import Html exposing (Html, p, text)
import Util exposing ((&))


type Msg
    = UpdateField String
    | OkayClick


type ExternalMsg
    = DoNothing
    | AddText String



-- UPDATE --


update : Msg -> String -> ( String, ExternalMsg )
update msg model =
    case msg of
        UpdateField str ->
            str & DoNothing

        OkayClick ->
            model & AddText model



-- VIEW --


view : String -> List (Html Msg)
view str =
    [ p [] [ text str ] ]



-- INIT --


init : String
init =
    ""
