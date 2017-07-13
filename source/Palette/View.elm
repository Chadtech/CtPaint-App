module Palette.View exposing (view)

import Html exposing (Html, Attribute, div)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Main.Model exposing (Model)
import Toolbar.Horizontal.Types exposing (Message(..))
import Palette.Types as Palette exposing (Swatches)
import Color exposing (Color)
import Util exposing ((:=), px)


view : Model -> Html Message
view model =
    div
        [ class "palette" ]
        [ swatches model.swatches
        , palette model
        ]



-- GENERAL PALETTE --


palette : Model -> Html Message
palette model =
    div
        [ class "general"
        , style
            [ "height"
                := (px (model.horizontalToolbarHeight - 10))
            ]
        ]
        (List.map paletteSquare model.palette)


paletteSquare : Color -> Html Message
paletteSquare color =
    div
        [ class "square"
        , background color
        , onClick (SetPrimarySwatch color)
        ]
        []



-- SWATCHES --


swatches : Swatches -> Html Message
swatches { primary, first, second, third } =
    div
        [ class "swatches" ]
        [ swatch primary "primary"
        , swatch first "first"
        , swatch second "second"
        , swatch third "third"
        ]


swatch : Color -> String -> Html Message
swatch color quadrant =
    div
        [ class ("swatch " ++ quadrant)
        , background color
        ]
        []



-- HELPERS --


background : Color -> Attribute Message
background =
    Palette.toHex
        >> (,) "background"
        >> List.singleton
        >> style
