module Menu.Text exposing
    ( Msg
    , css
    , init
    , track
    , update
    , view
    )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Tracking as Tracking
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom exposing (indent)
import Html.Events as Events
import Menu.Reply exposing (Reply(AddText))
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


update : Msg -> String -> Return String Msg Reply
update msg model =
    case msg of
        FieldUpdated str ->
            str
                |> R3.withNothing

        AddTextClicked ->
            model
                |> R2.withNoCmd
                |> R3.withReply (AddText model)



-- TRACK --


track : Msg -> Tracking.Event
track msg =
    case msg of
        FieldUpdated _ ->
            Tracking.none

        AddTextClicked ->
            "add-text-clicked"
                |> Tracking.noProps



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
    [ Html.textarea
        [ Events.onInput FieldUpdated
        , class [ Text ]
        , Attrs.spellcheck False
        , Attrs.value str
        ]
        []
    , Html.Custom.menuButton
        [ Events.onClick AddTextClicked ]
        [ Html.text "add text" ]
    ]
        |> Html.Custom.cardBody []
