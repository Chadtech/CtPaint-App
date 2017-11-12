module Text exposing (..)

import Chadtech.Colors exposing (backgroundx2, point)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, a, p, textarea)
import Html.Attributes exposing (class, spellcheck)
import Html.CssHelpers
import Html.Custom exposing (indent)
import Html.Events exposing (onClick, onInput)
import Reply exposing (Reply(AddText, NoReply))
import Tuple.Infix exposing ((&))


type Msg
    = FieldUpdated String
    | AddTextClicked



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
    [ (Css.class Text << List.append indent)
        [ outline none
        , fontFamilies [ "hfnss" ]
        , fontSize (em 2)
        , backgroundColor backgroundx2
        , color point
        , width (px 486)
        , height (px 222)
        , marginBottom (px 8)
        ]
    ]
        |> namespace textNamespace
        |> stylesheet


textNamespace : String
textNamespace =
    "Text"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace textNamespace


view : String -> List (Html Msg)
view str =
    [ textarea
        [ onInput FieldUpdated
        , class [ Text ]
        , spellcheck False
        ]
        [ Html.text str ]
    , Html.Custom.menuButton
        [ onClick AddTextClicked ]
        [ Html.text "Add Text" ]
    ]



-- INIT --


init : String
init =
    ""
