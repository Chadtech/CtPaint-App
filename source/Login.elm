module Login
    exposing
        ( Model
        , Msg(..)
        , css
        , init
        , update
        , view
        )

import Bool.Extra
import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Config exposing (Config)
import Data.User exposing (User)
import Data.Window as Window exposing (Window(ForgotPassword))
import Html exposing (Attribute, Html, div, input, p, span)
import Html.Attributes as Attr
    exposing
        ( placeholder
        , type_
        , value
        )
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Maybe.Extra
import Ports exposing (JsMsg(AttemptLogin, OpenNewWindow))
import Regex
import Reply
    exposing
        ( Reply
            ( AttemptingLogin
            , NoLongerLoggingIn
            , NoReply
            , SetUser
            )
        )
import Util


-- TYPES --


type alias Model =
    { email : String
    , password : String
    , showFields : Bool
    , errors : List ( Field, Problem )
    , responseError : Maybe Problem
    }


type Msg
    = FieldUpdated Field String
    | ForgotPasswordClicked
    | LoginButtonPressed
    | FormSubmitted
    | LoginFailed String
    | LoginSucceeded User


type Field
    = Email
    | Password


type Problem
    = EmailIsBlank
    | EmailIsInvalid
    | PasswordIsBlank
    | IncorrectEmailOrPassword
    | Other String



-- INIT --


init : Model
init =
    { email = ""
    , password = ""
    , showFields = True
    , errors = []
    , responseError = Nothing
    }



-- STYLES --


type Class
    = Error
    | ForgotLink
    | SubmitButton


css : Stylesheet
css =
    [ Css.class Error
        [ marginBottom (px 8) ]
    , Css.class ForgotLink
        [ color Ct.important0
        , hover
            [ cursor pointer
            , color Ct.important1
            ]
        ]
    , Css.class SubmitButton
        [ marginTop (px 8) ]
    ]
        |> namespace loginNamespace
        |> stylesheet


loginNamespace : String
loginNamespace =
    Html.Custom.makeNamespace "Login"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace loginNamespace


view : Model -> List (Html Msg)
view model =
    let
        value_ : String -> Attribute Msg
        value_ =
            Util.showField model.showFields >> value
    in
    [ responseErrorView model.responseError
    , Html.Custom.field
        [ onSubmit FormSubmitted ]
        [ p [] [ Html.text "email" ]
        , input
            [ onInput (FieldUpdated Email)
            , value_ model.email
            , placeholder "name@email.com"
            , Attr.spellcheck False
            ]
            []
        , input [ type_ "submit", Attr.hidden True ] []
        ]
    , fieldErrorView model.errors Email
    , Html.Custom.field
        [ onSubmit FormSubmitted ]
        [ p [] [ Html.text "password" ]
        , input
            [ onInput (FieldUpdated Password)
            , value_ model.password
            , type_ "password"
            , Attr.spellcheck False
            ]
            []
        , input [ type_ "submit", Attr.hidden True ] []
        ]
    , fieldErrorView model.errors Password
    , p
        []
        [ span
            [ class [ ForgotLink ]
            , onClick ForgotPasswordClicked
            ]
            [ Html.text "I forgot my password" ]
        ]
    , Html.Custom.menuButton
        [ class [ SubmitButton ]
        , onClick LoginButtonPressed
        ]
        [ Html.text "log in" ]
    ]


responseErrorView : Maybe Problem -> Html Msg
responseErrorView maybeProblem =
    case maybeProblem of
        Just problem ->
            Html.Custom.error
                [ class [ Error ] ]
                (errorStr problem)

        Nothing ->
            Html.text ""


fieldErrorView : List ( Field, Problem ) -> Field -> Html Msg
fieldErrorView errors field =
    let
        thisFieldsErrors =
            List.filter
                (Tuple.first >> (==) field)
                errors
    in
    case thisFieldsErrors of
        [] ->
            Html.text ""

        error :: _ ->
            error
                |> Tuple.second
                |> errorStr
                |> Html.Custom.error [ class [ Error ] ]


errorStr : Problem -> String
errorStr problem =
    case problem of
        EmailIsBlank ->
            "Email cant be blank"

        EmailIsInvalid ->
            "This email isnt valid"

        PasswordIsBlank ->
            "Password cant be blank"

        IncorrectEmailOrPassword ->
            "The email and password dont match"

        Other str ->
            str



-- UPDATE --


update : Config -> Msg -> Model -> ( Model, Cmd Msg, Reply )
update config msg model =
    case msg of
        FieldUpdated Email email ->
            { model | email = email }
                |> Reply.nothing

        ForgotPasswordClicked ->
            ( model
            , openForgotPassword config
            , NoReply
            )

        FieldUpdated Password password ->
            { model | password = password }
                |> Reply.nothing

        LoginButtonPressed ->
            attemptLogin model

        FormSubmitted ->
            attemptLogin model

        LoginFailed err ->
            { model
                | responseError = Just (errorToProblem err)
                , showFields = True
                , password = ""
            }
                |> Reply.fromModel
                    Cmd.none
                    NoLongerLoggingIn

        LoginSucceeded user ->
            ( { model | email = "", password = "" }
            , Ports.returnFocus
            , SetUser user
            )


openForgotPassword : Config -> Cmd Msg
openForgotPassword { mountPath } =
    ForgotPassword
        |> Window.toUrl mountPath
        |> OpenNewWindow
        |> Ports.send


errorToProblem : String -> Problem
errorToProblem err =
    case err of
        "UserNotFoundException: User does not exist." ->
            IncorrectEmailOrPassword

        "NotAuthorizedException: Incorrect username or password." ->
            IncorrectEmailOrPassword

        other ->
            Other other


attemptLogin : Model -> ( Model, Cmd Msg, Reply )
attemptLogin model =
    { model
        | responseError = Nothing
    }
        |> validate
        |> submitIfNoErrors


validate : Model -> Model
validate model =
    { model
        | errors = determineErrors model
    }


determineErrors : Model -> List ( Field, Problem )
determineErrors model =
    [ ( Email, EmailIsBlank )
        |> check (String.isEmpty model.email)
    , ( Email, EmailIsInvalid )
        |> check (emailIsInvalid model.email)
    , ( Password, PasswordIsBlank )
        |> check (String.isEmpty model.password)
    ]
        |> Maybe.Extra.values


emailIsInvalid : String -> Bool
emailIsInvalid email =
    [ Regex.contains (Regex.regex "[A-Za-z0-9]@[A-Za-z0-9]")
    , Regex.contains (Regex.regex "[A-Za-z0-9]\\.[A-Za-z]*")
    ]
        |> flip Bool.Extra.allPass email
        |> not


check : Bool -> ( Field, Problem ) -> Maybe ( Field, Problem )
check condition error =
    if condition then
        Just error
    else
        Nothing


submitIfNoErrors : Model -> ( Model, Cmd Msg, Reply )
submitIfNoErrors model =
    if List.isEmpty model.errors then
        ( { model | showFields = False, password = "" }
        , AttemptLogin model.email model.password
            |> Ports.send
        , AttemptingLogin
        )
    else
        model |> Reply.nothing
