module Project
    exposing
        ( Model
        , Msg(..)
        , css
        , init
        , update
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Project as Project exposing (Project)
import Html
    exposing
        ( Html
        , input
        , p
        )
import Html.Attributes exposing (value)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onInput, onSubmit)
import Reply exposing (Reply(NoReply, SetProject))
import Tuple.Infix exposing ((&), (|&))


-- TYPES --


type alias Model =
    { project : Project
    , state : State
    }


type State
    = Ready
    | Saving
    | Fail Problem


type Problem
    = Other String


toProject : Model -> Project
toProject model =
    model.project


type Msg
    = NameUpdated String
    | SaveClicked



-- INIT --


init : Project -> Model
init project =
    { project = project
    , state = Ready
    }



-- STYLES --


type Class
    = Field


css : Stylesheet
css =
    []
        |> namespace projectNamespace
        |> stylesheet


projectNamespace : String
projectNamespace =
    Html.Custom.makeNamespace "Project"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace projectNamespace


view : Model -> List (Html Msg)
view model =
    case model.state of
        Ready ->
            readyView model

        Saving ->
            savingView model

        Fail problem ->
            failView problem


readyView : Model -> List (Html Msg)
readyView model =
    [ Html.Custom.field
        [ class [ Field ]
        , onSubmit SaveClicked
        ]
        [ p [] [ Html.text "name" ]
        , input
            [ onInput NameUpdated
            , value model.project.name
            ]
            []
        ]
    ]


savingView : Model -> List (Html Msg)
savingView model =
    []


failView : Problem -> List (Html Msg)
failView problem =
    []



-- UPDATE --


update : Msg -> Model -> ( Model, Reply )
update msg model =
    case msg of
        NameUpdated name ->
            { model
                | project =
                    Project.setName name model.project
            }
                & NoReply

        SaveClicked ->
            model & SetProject (toProject model)
