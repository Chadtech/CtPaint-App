module Login exposing (..)

import Data.User exposing (User)
import Html exposing (Attribute, Html, div, input, p)
import Html.Attributes exposing (hidden, placeholder, type_, value)
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Maybe.Extra
import Ports exposing (JsMsg(AttemptLogin))
import Reply exposing (Reply(AttemptingLogin, NoReply, SetToNoSession, SetUser))
import Tuple.Infix exposing ((&))
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
    | LoginButtonPressed
    | FormSubmitted
    | LoginFailed String
    | LoginSucceeded User


type Field
    = Email
    | Password


type Problem
    = EmailIsBlank
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



-- VIEW --


view : Model -> List (Html Msg)
view model =
    let
        value_ : String -> Attribute Msg
        value_ =
            Util.showField model.showFields >> value
    in
    [ Html.Custom.field
        [ onSubmit FormSubmitted ]
        [ p [] [ Html.text "email" ]
        , input
            [ onInput (FieldUpdated Email)
            , value_ model.email
            , placeholder "name@email.com"
            ]
            []
        , input [ type_ "submit", hidden True ] []
        ]
    , Html.Custom.field
        [ onSubmit FormSubmitted ]
        [ p [] [ Html.text "password" ]
        , input
            [ onInput (FieldUpdated Password)
            , value_ model.password
            , type_ "password"
            ]
            []
        , input [ type_ "submit", hidden True ] []
        ]
    , Html.Custom.menuButton
        [ onClick LoginButtonPressed ]
        [ Html.text "log in" ]
    ]



-- UPDATE --


update : Msg -> Model -> ( ( Model, Cmd Msg ), Reply )
update msg model =
    case msg of
        FieldUpdated Email email ->
            { model | email = email }
                & Cmd.none
                & NoReply

        FieldUpdated Password password ->
            { model | password = password }
                & Cmd.none
                & NoReply

        LoginButtonPressed ->
            attemptLogin model

        FormSubmitted ->
            attemptLogin model

        LoginFailed err ->
            { model
                | responseError = Just (errorToProblem err)
            }
                & Cmd.none
                & SetToNoSession

        LoginSucceeded user ->
            model & Cmd.none & SetUser user


errorToProblem : String -> Problem
errorToProblem err =
    case err of
        "UserNotFoundException: User does not exist." ->
            IncorrectEmailOrPassword

        "NotAuthorizedException: Incorrect username or password." ->
            IncorrectEmailOrPassword

        other ->
            Other other


attemptLogin : Model -> ( ( Model, Cmd Msg ), Reply )
attemptLogin model =
    validate model
        |> submitIfNoErrors
        & AttemptingLogin


validate : Model -> Model
validate model =
    { model
        | errors = determineErrors model
    }


determineErrors : Model -> List ( Field, Problem )
determineErrors model =
    [ ( Email, EmailIsBlank ) |> check (String.isEmpty model.email)
    , ( Password, PasswordIsBlank ) |> check (String.isEmpty model.password)
    ]
        |> Maybe.Extra.values


check : Bool -> ( Field, Problem ) -> Maybe ( Field, Problem )
check condition error =
    if condition then
        Just error
    else
        Nothing


submitIfNoErrors : Model -> ( Model, Cmd Msg )
submitIfNoErrors model =
    if List.isEmpty model.errors then
        let
            cmd =
                AttemptLogin model.email model.password
                    |> Ports.send
        in
        { model
            | showFields = False
            , password = ""
        }
            & cmd
    else
        model & Cmd.none
