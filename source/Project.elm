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
import Data.Project exposing (Project)
import Html
    exposing
        ( Html
        )
import Html.CssHelpers
import Html.Custom
import Reply exposing (Reply(NoReply, SetProject))
import Tuple.Infix exposing ((&), (|&))


-- TYPES --


type alias Model =
    Project


toProject : Model -> Project
toProject model =
    model


type Msg
    = NameUpdated String
    | SaveClicked



-- INIT --


init : Project -> Model
init project =
    project



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
    []



-- UPDATE --


update : Msg -> Model -> ( Model, Reply )
update msg model =
    case msg of
        NameUpdated name ->
            { model | name = name } & NoReply

        SaveClicked ->
            model & SetProject (toProject model)
