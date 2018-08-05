module Menu.Text
    exposing
        ( Msg
        , css
        , init
        , update
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Taco exposing (Taco)
import Html exposing (Html, a, p, textarea)
import Html.Attributes exposing (spellcheck, value)
import Html.CssHelpers
import Html.Custom exposing (indent)
import Html.Events exposing (onClick, onInput)
import Menu.Reply exposing (Reply(AddText))
import Ports
import Return2 as R2
import Return3 as R3 exposing (Return)


-- TYPES --


type Msg
    = FieldUpdated String
    | AddTextClicked



-- INIT --


init : String
init =
    ""



-- UPDATE --


update : Taco -> Msg -> String -> Return String Msg Reply
update taco msg model =
    case msg of
        FieldUpdated str ->
            str
                |> R3.withNothing

        AddTextClicked ->
            model
                |> R2.withNoCmd
                |> R3.withReply (AddText model)



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
