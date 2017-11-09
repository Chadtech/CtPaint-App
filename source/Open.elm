module Open exposing (..)

import Html exposing (Html, div)
import List.Selection exposing (Selection)
import Tuple.Infix exposing ((&))


-- TYPES --


type alias Model =
    { status : Status
    , options : Selection String
    , errors : List Error
    }


type Error
    = FailedToLoad
    | AttemptToLoadWhileNoChoiceMade


type Status
    = LoadingOptions
    | FailedToLoadOptions
    | Choosing
    | LoadingCanvas String
    | FailedToLoadCanvas String


type Msg
    = ClickedOption String
    | LoadButtonClicked
    | LoadCanvasFailed String
    | LoadOptionsFailed


type Reply
    = NoReply
    | Load String



-- INIT --


init : Model
init =
    { status = LoadingOptions
    , options = List.Selection.fromList []
    , errors = []
    }



-- VIEW --


view : Model -> List (Html Msg)
view model =
    []



-- UPDATE --


update : Msg -> Model -> ( Model, Reply )
update msg model =
    case msg of
        ClickedOption option ->
            { model
                | options =
                    List.Selection.select
                        option
                        model.options
            }
                & NoReply

        LoadButtonClicked ->
            case model.status of
                Choosing ->
                    attemptLoad model

                _ ->
                    model & NoReply

        LoadCanvasFailed fn ->
            { model
                | status = FailedToLoadCanvas fn
            }
                & NoReply

        LoadOptionsFailed ->
            { model
                | status = FailedToLoadOptions
            }
                & NoReply


attemptLoad : Model -> ( Model, Reply )
attemptLoad model =
    case List.Selection.selected model.options of
        Just choice ->
            { model
                | status = LoadingCanvas choice
            }
                & Load choice

        Nothing ->
            { model
                | errors =
                    AttemptToLoadWhileNoChoiceMade :: model.errors
            }
                & NoReply