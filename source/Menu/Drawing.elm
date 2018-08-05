module Menu.Drawing
    exposing
        ( Model
        , Msg(..)
        , css
        , init
        , update
        , view
        )

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Taco exposing (Taco)
import Html exposing (Html, input, p)
import Html.Attributes exposing (value)
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Menu.Reply exposing (Reply(SaveDrawingAttrs))
import Ports
import Return2 as R2
import Return3 as R3 exposing (Return)


-- TYPES --


type alias Model =
    { name : String
    , state : State
    }


type State
    = Ready
    | Saving
    | Fail Problem


type Problem
    = Other String


type Msg
    = NameUpdated String
    | SaveClicked



-- INIT --


init : String -> Model
init name =
    { name = name
    , state = Ready
    }



-- STYLES --


type Class
    = Field
    | Button
    | Error


css : Stylesheet
css =
    [ Css.class Field
        [ marginBottom (px 0) ]
    , Css.class Button
        [ marginTop (px 8) ]
    , Css.class Error
        [ backgroundColor Ct.lowWarning ]
    ]
        |> namespace projectNamespace
        |> stylesheet


projectNamespace : String
projectNamespace =
    Html.Custom.makeNamespace "DrawingMenu"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace projectNamespace


view : Model -> Html Msg
view model =
    case model.state of
        Ready ->
            readyView model
                |> Html.Custom.cardBody []

        Saving ->
            savingView model
                |> Html.Custom.cardBody []

        Fail problem ->
            failView problem
                |> Html.Custom.cardBody [ class [ Error ] ]


readyView : Model -> List (Html Msg)
readyView model =
    [ Html.Custom.field
        [ class [ Field ]
        , onSubmit SaveClicked
        ]
        [ p [] [ Html.text "name" ]
        , input
            [ onInput NameUpdated
            , value model.name
            ]
            []
        , Html.Custom.menuButton
            [ class [ Button ]
            , onClick SaveClicked
            ]
            [ Html.text "save" ]
        ]
    ]


savingView : Model -> List (Html Msg)
savingView model =
    []


failView : Problem -> List (Html Msg)
failView problem =
    []



-- UPDATE --


update : Taco -> Msg -> Model -> Return Model Msg Reply
update taco msg model =
    case msg of
        NameUpdated name ->
            { model | name = name }
                |> R3.withNothing

        SaveClicked ->
            { model | state = Saving }
                |> R2.withNoCmd
                |> R3.withReply (SaveDrawingAttrs model.name)
