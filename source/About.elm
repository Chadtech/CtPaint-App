module About
    exposing
        ( State
        , css
        , view
        )

import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Html exposing (Html, br, p)
import Html.CssHelpers
import Html.Custom


type alias State =
    { buildNumber : String }



-- STYLES --


type Class
    = Noop


css : Stylesheet
css =
    [ Css.Elements.p
        [ maxWidth (px 400) ]
    ]
        |> namespace aboutNamespace
        |> stylesheet


aboutNamespace : String
aboutNamespace =
    Html.Custom.makeNamespace "About"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace aboutNamespace


view : State -> List (Html msg)
view { buildNumber } =
    [ p_ "CtPaint 2017 Basic "
    , p_ ("build number " ++ buildNumber)
    , br [] []
    , p_ "CtPaint is a cloud based image editor. It provides good image editing and pixel art functionality, seamlessly integreated into the internet."
    , br [] []
    , p_ "It was made by one guy named \"Chadtech\" over the course of two years in his free time. You can reach him at chadtech@programhouse.us."
    ]


p_ : String -> Html msg
p_ str =
    p [] [ Html.text str ]
