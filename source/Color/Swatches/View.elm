module Color.Swatches.View
    exposing
        ( css
        , view
        )

import Color
import Color.Style exposing (paletteSquareSize)
import Color.Swatches.Data exposing (Swatches)
import Color.Util
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Html exposing (Html, div)
import Html.CssHelpers
import Html.Custom exposing (indent)


-- STYLES --


type Class
    = Container
    | Top
    | Left
    | Bottom
    | Right
    | Swatch


css : Stylesheet
css =
    [ Css.class Container
        [ marginLeft (px -27)
        , position absolute
        , top (px 4)
        , left (px 0)
        ]
    , (Css.class Swatch << List.append indent)
        [ position absolute
        , height (px paletteSquareSize)
        ]
    , Css.class Top
        [ top (px 0)
        , left (px 0)
        , width (px 98)
        ]
    , Css.class Left
        [ top (px 28)
        , left (px 0)
        , width (px paletteSquareSize)
        ]
    , Css.class Bottom
        [ top (px 28)
        , left (px 27)
        , width (px 44)
        ]
    , Css.class Right
        [ top (px 28)
        , left (px 78)
        , width (px paletteSquareSize)
        ]
    ]
        |> namespace moduleNamespace
        |> stylesheet


moduleNamespace : String
moduleNamespace =
    Html.Custom.makeNamespace "Swatches"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace moduleNamespace


view : Swatches -> Html msg
view { top, left, bottom, right } =
    div
        [ class [ Container ] ]
        [ swatch top Top
        , swatch left Left
        , swatch bottom Bottom
        , swatch right Right
        ]


swatch : Color.Color -> Class -> Html msg
swatch color quadrant =
    div
        [ class [ Swatch, quadrant ]
        , Color.Util.background color
        ]
        []
