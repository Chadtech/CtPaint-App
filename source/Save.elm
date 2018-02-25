module Save
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
import Html exposing (Html, div, p)
import Html.CssHelpers
import Html.Custom
import Tuple.Infix exposing ((&))


type Model
    = Loading


type Msg
    = Noop



-- INIT --


init : Model
init =
    Loading



-- STYLES --


type Class
    = None


css : Stylesheet
css =
    []
        |> namespace saveNamespace
        |> stylesheet


saveNamespace : String
saveNamespace =
    Html.Custom.makeNamespace "SaveModule"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace saveNamespace


view : Model -> List (Html Msg)
view model =
    []



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update Noop model =
    model & Cmd.none
