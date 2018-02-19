module Error exposing (css, view)

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Html exposing (Attribute, Html, div, p)
import Html.CssHelpers
import Html.Custom


-- STYLES --


type Class
    = ScreenFiller
    | TextContainer


css : Stylesheet
css =
    [ Css.class ScreenFiller
        [ width (pct 100)
        , height (pct 100)
        , backgroundColor Ct.critical
        , zIndex (int 5)
        , position fixed
        , top (px 0)
        , left (px 0)
        ]
    , Css.class TextContainer
        [ width (px 800)
        , height (vh 60)
        , overflow scroll
        , transform (translate2 (pct -50) (pct -50))
        , position absolute
        , left (pct 50)
        , top (pct 50)
        , children
            [ Css.Elements.p
                [ color Ct.point1 ]
            ]
        ]
    ]
        |> namespace errorNamespace
        |> stylesheet


errorNamespace : String
errorNamespace =
    Html.Custom.makeNamespace "Error"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace errorNamespace


view : String -> Html msg
view err =
    div
        [ class [ ScreenFiller ] ]
        [ div
            [ class [ TextContainer ] ]
            [ p [] [ Html.text "Error!" ]
            , p [] [ Html.text "Oh no, something went wrong. Im so sorry." ]
            , p [] [ Html.text "------" ]
            , p [] [ Html.text err ]
            ]
        ]
