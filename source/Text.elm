module Text exposing (..)

import Html exposing (Html, a, p, text, textarea)
import Html.Attributes exposing (class, spellcheck)
import Html.Events exposing (onClick, onInput)
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
    [ textarea
        [ onInput UpdateField
        , class "text-menu"
        , spellcheck False
        ]
        [ text str ]
    , a
        [ onClick OkayClick
        , class "submit-button"
        ]
        [ text "Add Text" ]
    ]



-- INIT --


init : String
init =
    ""
