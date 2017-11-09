module Login exposing (..)

import Html exposing (Html, div)
import Maybe.Extra
import Tuple.Infix exposing ((&))


-- TYPES --


type alias Model =
    { email : String
    , password : String
    , showFields : Bool
    , errors : List ( Field, Problem )
    , responseError : Maybe Problem
    }


type Msg
    = FieldChanged Field String
    | LoginButtonPressed
    | FormSubmitted
    | LoginFailed String


type Reply
    = NoReply
    | AttemptLogin String String


type Field
    = Email
    | Password


type Problem
    = EmailIsBlank
    | PasswordIsBlank
    | Unknown



-- INIT --


init : Model
init =
    { email = ""
    , password = ""
    , showFields = True
    , errors = []
    , responseError = Nothing
    }


view : Model -> List (Html Msg)
view model =
    []



-- UPDATE --


update : Msg -> Model -> ( Model, Reply )
update msg model =
    case msg of
        FieldChanged Email email ->
            { model | email = email } & NoReply

        FieldChanged Password password ->
            { model | password = password } & NoReply

        LoginButtonPressed ->
            attemptLogin model

        FormSubmitted ->
            attemptLogin model

        LoginFailed err ->
            { model
                | responseError = Just Unknown
            }
                & NoReply


attemptLogin : Model -> ( Model, Reply )
attemptLogin model =
    validate model |> submitIfNoErrors


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


submitIfNoErrors : Model -> ( Model, Reply )
submitIfNoErrors model =
    if List.isEmpty model.errors then
        model & AttemptLogin model.email model.password
    else
        model & NoReply
