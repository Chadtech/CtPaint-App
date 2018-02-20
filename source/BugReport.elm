module BugReport
    exposing
        ( Model
        , Msg
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
import Ports exposing (JsMsg(ReportBug))
import Tuple.Infix exposing ((&))


-- TYPES --


type Msg
    = FieldUpdated String
    | SubmitBugClicked


type Model
    = Ready String
    | Sending
    | Fail Problem
    | Success


type Problem
    = Other String


init : Model
init =
    Ready ""



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FieldUpdated str ->
            updateField str model

        SubmitBugClicked ->
            submitBug model


updateField : String -> Model -> ( Model, Cmd Msg )
updateField str model =
    case model of
        Ready _ ->
            Ready str & Cmd.none

        _ ->
            model & Cmd.none


submitBug : Model -> ( Model, Cmd Msg )
submitBug model =
    case model of
        Ready "" ->
            model & Cmd.none

        Ready str ->
            Sending & Ports.send (ReportBug str)

        _ ->
            model & Cmd.none



-- STYLES --


type Class
    = Text


css : Stylesheet
css =
    [ Css.class Text
        Html.Custom.textAreaStyle
    ]
        |> namespace bugReportNamespace
        |> stylesheet


bugReportNamespace : String
bugReportNamespace =
    Html.Custom.makeNamespace "BugReport"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace bugReportNamespace


view : Model -> List (Html Msg)
view model =
    case model of
        Ready str ->
            readyView str

        _ ->
            []


readyView : String -> List (Html Msg)
readyView str =
    [ textarea
        [ onInput FieldUpdated
        , class [ Text ]
        , spellcheck False
        , value str
        ]
        []
    , Html.Custom.menuButton
        [ onClick SubmitBugClicked ]
        [ Html.text "submit bug" ]
    ]
