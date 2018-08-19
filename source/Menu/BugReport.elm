module Menu.BugReport
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
import Menu.Reply exposing (Reply(CloseMenu))
import Return2 as R2
import Return3 as R3 exposing (Return)
import Util exposing (def)


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


update : Msg -> Model -> Return Model Msg Reply
update msg model =
    case msg of
        FieldUpdated str ->
            updateField str model
                |> R3.withNothing

        SubmitBugClicked ->
            submitBug model
                |> R3.withNoReply

        TwoSecondsExpired ->
            model
                |> R2.withNoCmd
                |> R3.withReply CloseMenu


updateField : String -> Model -> Model
updateField str model =
    case model of
        Ready _ ->
            Ready str

        _ ->
            model


submitBug : Model -> ( Model, Cmd Msg )
submitBug model =
    case model of
        Ready "" ->
            model
                |> R2.withNoCmd

        Ready str ->
            Util.delay 2000 TwoSecondsExpired
                |> R2.withModel Done

        _ ->
            model
                |> R2.withNoCmd



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
            [ def Text True
            , def Disabled disabled
            ]
        , spellcheck False
        , value str
        ]
        []
    , Html.Custom.menuButton
        [ classList
            [ def SubmitButton True
            , def Disabled disabled
            ]
        , onClick SubmitBugClicked
        ]
        [ Html.text "submit bug" ]
    ]
