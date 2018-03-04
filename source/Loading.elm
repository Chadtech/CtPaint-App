module Loading
    exposing
        ( Model
        , css
        , init
        , view
        )

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Project exposing (Project)
import Html exposing (Html, p)
import Html.CssHelpers
import Html.Custom
import Reply exposing (Reply(SetProject))


-- TYPES --


type alias Model =
    Maybe String


init : Maybe String -> Model
init =
    identity



-- STYLES --


type Class
    = Text


css : Stylesheet
css =
    [ Css.class Text
        [ marginBottom (px 8) ]
    ]
        |> namespace loadingNamespace
        |> stylesheet


loadingNamespace : String
loadingNamespace =
    Html.Custom.makeNamespace "Loading"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace loadingNamespace


view : Model -> List (Html msg)
view model =
    case model of
        Just name ->
            [ p
                [ class [ Text ] ]
                [ presentName name ]
            , Html.Custom.spinner []
            ]

        Nothing ->
            [ p
                [ class [ Text ] ]
                [ Html.text "loading" ]
            , Html.Custom.spinner []
            ]


presentName : String -> Html msg
presentName name =
    [ "loading \""
    , name
    , "\""
    ]
        |> String.concat
        |> Html.text
