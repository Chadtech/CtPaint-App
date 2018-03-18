module BugReport
    exposing
        ( Model
        , Msg
        , css
        , init
        , update
        , view
        )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, a, br, p, textarea)
import Html.Attributes exposing (spellcheck, value)
import Html.CssHelpers
import Html.Custom exposing (indent)
import Html.Events exposing (onClick, onInput)
import Ports exposing (JsMsg(ReportBug))
import Reply exposing (Reply(CloseMenu, NoReply))
import Tuple.Infix exposing ((&), (:=))
import Util


-- TYPES --


type Msg
    = FieldUpdated String
    | SubmitBugClicked
    | TwoSecondsExpired


type Model
    = NotLoggedIn
    | Ready String
    | Done


type Problem
    = Other String


init : Bool -> Model
init loggedIn =
    if loggedIn then
        Ready ""
    else
        NotLoggedIn



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg, Reply )
update msg model =
    case msg of
        FieldUpdated str ->
            updateField str model
                |> Reply.nothing

        SubmitBugClicked ->
            submitBug model

        TwoSecondsExpired ->
            ( model
            , Cmd.none
            , CloseMenu
            )


updateField : String -> Model -> Model
updateField str model =
    case model of
        Ready _ ->
            Ready str

        _ ->
            model


submitBug : Model -> ( Model, Cmd Msg, Reply )
submitBug model =
    case model of
        Ready "" ->
            model |> Reply.nothing

        Ready str ->
            ( Done
            , Cmd.batch
                [ Ports.send (ReportBug str)
                , Util.delay 2000 TwoSecondsExpired
                ]
            , NoReply
            )

        _ ->
            model |> Reply.nothing



-- STYLES --


type Class
    = Text
    | NotLoggedInText
    | Disabled
    | SubmitButton


css : Stylesheet
css =
    [ Css.class Text Html.Custom.textAreaStyle
    , Css.class NotLoggedInText
        [ width (px 400) ]
    , Css.class Disabled
        [ backgroundColor Ct.ignorable1 ]
    , Css.class SubmitButton
        [ withClass Disabled
            [ active Html.Custom.outdent ]
        ]
    ]
        |> namespace bugReportNamespace
        |> stylesheet


bugReportNamespace : String
bugReportNamespace =
    Html.Custom.makeNamespace "BugReport"



-- VIEW --


{ classList, class } =
    Html.CssHelpers.withNamespace bugReportNamespace


view : Model -> Html Msg
view =
    viewBody >> Html.Custom.cardBody []


viewBody : Model -> List (Html Msg)
viewBody model =
    case model of
        Ready str ->
            loggedInView str False

        Done ->
            loggedInView "Submitted! Thank you!" True

        NotLoggedIn ->
            notLoggedInView


notLoggedInView : List (Html Msg)
notLoggedInView =
    [ p
        [ class [ NotLoggedInText ] ]
        [ Html.text notLoggedInText ]
    , br [] []
    , p
        [ class [ NotLoggedInText ] ]
        [ Html.text thanks ]
    ]


notLoggedInText : String
notLoggedInText =
    """
    Please email ctpaint@programhouse.us to report your bug.
    If you log in, you can submit your bug directly from this
    window.
    """


thanks : String
thanks =
    """
    Thank you so much for submitting your report, it
    really helps me develop CtPaint.
    """


loggedInView : String -> Bool -> List (Html Msg)
loggedInView str disabled =
    [ textarea
        [ onInput FieldUpdated
        , classList
            [ Text := True
            , Disabled := disabled
            ]
        , spellcheck False
        , value str
        ]
        []
    , Html.Custom.menuButton
        [ classList
            [ SubmitButton := True
            , Disabled := disabled
            ]
        , onClick SubmitBugClicked
        ]
        [ Html.text "submit bug" ]
    ]
