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
    = Saving String


type Msg
    = Noop



-- INIT --


init : String -> Model
init =
    Saving



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Noop ->
            model & Cmd.none



-- STYLES --


type Class
    = Text


css : Stylesheet
css =
    [ Css.class Text
        [ marginBottom (px 8) ]
    ]
        |> namespace saveNamespace
        |> stylesheet


saveNamespace : String
saveNamespace =
    Html.Custom.makeNamespace "SaveModule"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace saveNamespace


view : Model -> List (Html msg)
view model =
    case model of
        Saving str ->
            [ p
                [ class [ Text ] ]
                [ Html.text (savingText str) ]
            , Html.Custom.spinner []
            ]


savingText : String -> String
savingText str =
    "saving \"" ++ str ++ "\""
