module Text
    exposing
        ( Msg
        , css
        , init
        , update
        , view
        )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, a, p, textarea)
import Html.Attributes exposing (spellcheck, value)
import Html.CssHelpers
import Html.Custom exposing (indent)
import Html.Events exposing (onClick, onInput)
import Reply exposing (Reply(AddText, NoReply))
import Tuple.Infix exposing ((&))


-- TYPES --


type Msg
    = FieldUpdated String
    | AddTextClicked



-- INIT --


init : String
init =
    ""



-- UPDATE --


update : Msg -> String -> ( String, Reply )
update msg model =
    case msg of
        FieldUpdated str ->
            str & NoReply

        AddTextClicked ->
            model & AddText model



-- STYLES --


type Class
    = Text


css : Stylesheet
css =
    [ Css.class Text
        Html.Custom.textAreaStyle
    ]
        |> namespace textNamespace
        |> stylesheet


textNamespace : String
textNamespace =
    Html.Custom.makeNamespace "Text"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace textNamespace


view : String -> List (Html Msg)
view str =
    [ textarea
        [ onInput FieldUpdated
        , class [ Text ]
        , spellcheck False
        , value str
        ]
        []
    , Html.Custom.menuButton
        [ onClick AddTextClicked ]
        [ Html.text "add text" ]
    ]
