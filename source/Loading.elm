module Loading exposing (update, view)

import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Project exposing (Project)
import Html exposing (Html, p)
import Html.CssHelpers
import Html.Custom
import Reply exposing (Reply(SetProject))


-- TYPES --


type Msg
    = ProjectLoaded Project



-- STYLES --


type Class
    = Text


css : Stylesheet
css =
    []
        |> namespace loadingNamespace
        |> stylesheet


loadingNamespace : String
loadingNamespace =
    Html.Custom.makeNamespace "Loading"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace loadingNamespace


view : String -> List (Html msg)
view name =
    [ p [ class [ Text ] ] [ presentName name ] ]


presentName : String -> Html msg
presentName name =
    "loading \""
        ++ name
        ++ "\""
        |> Html.text



-- UPDATE --


update : Msg -> Reply
update msg =
    case msg of
        ProjectLoaded project ->
            SetProject project
