module Text
    exposing
        ( Msg
        , css
        , init
        , update
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, a, p, textarea)
import Html.Attributes exposing (spellcheck, value)
import Html.CssHelpers
import Html.Custom exposing (indent)
import Html.Events exposing (onClick, onInput)
import Reply as R exposing (Reply(AddText))


-- TYPES --


type Msg
    = FieldUpdated String
    | AddTextClicked



-- INIT --


init : String
init =
    ""



-- UPDATE --


update : Msg -> String -> ( String, Maybe Reply )
update msg model =
    case msg of
        FieldUpdated str ->
            str
                |> R.withNoReply

        AddTextClicked ->
            model
                |> R.withReply (AddText model)



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


view : String -> Html Msg
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
        |> Html.Custom.cardBody []
