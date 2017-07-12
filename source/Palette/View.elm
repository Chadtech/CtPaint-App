module Palette.View exposing (view)

import Html exposing (Html, Attribute, div)
import Html.Attributes exposing (class, style)
import Main.Model exposing (Model)
import Toolbar.Horizontal.Types exposing (Message(..))
import Palette.Types as Palette exposing (Swatches)
import Color exposing (Color)


view : Model -> Html Message
view model =
    div
        [ class "palette" ]
        [ swatches model.swatches ]


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


background : Color -> Attribute Message
background =
    Palette.toHex
        >> (,) "background"
        >> List.singleton
        >> style
