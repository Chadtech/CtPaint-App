module Palette.View exposing (view)

import Html exposing (Html, Attribute, div)
import Html.Attributes exposing (class, classList, style)
import Html.Events exposing (onClick, onDoubleClick)
import Main.Model exposing (Model)
import Toolbar.Horizontal.Types exposing (Message(..))
import Palette.Types as Palette exposing (Swatches)
import Color exposing (Color)
import Util exposing ((:=), px, height)
import Array


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
    let
        square : Int -> Color -> Html Message
        square =
            paletteSquare
                model.colorPicker.show
                model.colorPicker.index

        paletteSquares =
            model.palette
                |> Array.indexedMap square
                |> Array.toList
    in
        div
            [ class "general"
            , style
                [ height (model.horizontalToolbarHeight - 10) ]
            ]
            paletteSquares


paletteSquare : Bool -> Int -> Int -> Color -> Html Message
paletteSquare show selectedIndex index color =
    div
        [ class "square"
        , background color
        , onClick (PaletteSquareClick color index)
        ]
        (highLight (show && (index == selectedIndex)))


highLight : Bool -> List (Html Message)
highLight show =
    if show then
        [ div
            [ class "high-light" ]
            []
        ]
    else
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
