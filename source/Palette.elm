module Palette
    exposing
        ( Msg
        , css
        , paletteView
        , swatchesView
        , update
        )

import Array exposing (Array)
import Chadtech.Colors
    exposing
        ( backgroundx2
        , ignorable1
        , ignorable2
        , ignorable3
        , point
        )
import Color exposing (Color)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Color exposing (Model)
import Data.Palette exposing (Swatches)
import Data.Picker as Picker
import Helpers.Color
import Html exposing (Attribute, Html, a, div, p, span)
import Html.Attributes exposing (class, classList, style)
import Html.CssHelpers
import Html.Custom exposing (cannotSelect, indent, outdent)
import Html.Events exposing (onClick)
import Util
    exposing
        ( background
        , maybeCons
        , tbw
        , toColor
        , toHex
        , toolbarWidth
        )


-- TYPES --


type Msg
    = PaletteSquareClick Color.Color
    | OpenColorPicker Color.Color Int
    | AddPaletteSquare



-- UPDATE --


update : Msg -> Model -> Model
update msg model =
    case msg of
        PaletteSquareClick color ->
            { model
                | swatches =
                    Helpers.Color.setPrimary color model.swatches
            }

        OpenColorPicker color index ->
            { model
                | picker =
                    Picker.init True index color
            }

        AddPaletteSquare ->
            { model
                | palette =
                    Array.push
                        model.swatches.second
                        model.palette
            }



-- STYLES --


type Class
    = SwatchesContainer
    | Swatch
    | Primary
    | First
    | Second
    | Third
    | Colors
    | Square
    | Selected
    | Plus


css : Stylesheet
css =
    [ Css.class SwatchesContainer
        [ marginLeft (px -27)
        , position absolute
        , top (px 4)
        , left (px 0)
        ]
    , (Css.class Swatch << List.append indent)
        [ position absolute
        , height (px 20)
        ]
    , Css.class Primary
        [ top (px 0)
        , left (px 0)
        , width (px 98)
        ]
    , Css.class First
        [ top (px 28)
        , left (px 0)
        , width (px 20)
        ]
    , Css.class Second
        [ top (px 28)
        , left (px 27)
        , width (px 44)
        ]
    , Css.class Third
        [ top (px 28)
        , left (px 78)
        , width (px 20)
        ]
    , (Css.class Colors << List.append indent)
        [ backgroundColor backgroundx2
        , width (calc (pct 100) minus (px 484))
        , position absolute
        , left (px 79)
        , top (px 4)
        , overflowY auto
        ]
    , Css.class Square
        [ height (px 20)
        , width (px 20)
        , borderTop3 (px 1) solid ignorable3
        , borderLeft3 (px 1) solid ignorable3
        , borderRight3 (px 1) solid ignorable1
        , borderBottom3 (px 1) solid ignorable1
        , display inlineBlock
        , float left
        ]
    , (Css.class Plus << List.append outdent << List.append cannotSelect)
        [ color point
        , cursor pointer
        , active indent
        , fontFamilies [ "hfnss" ]
        , property "-webkit-font-smoothing" "none"
        , fontSize (em 2)
        , height (px 18)
        , width (px 18)
        , backgroundColor ignorable2
        , textAlign center
        ]
    ]
        |> namespace paletteNamespace
        |> stylesheet


paletteNamespace : String
paletteNamespace =
    Html.Custom.makeNamespace "Palette"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace paletteNamespace



-- PALETTE --


paletteView : Model -> Html Msg
paletteView model =
    let
        square : ( Int, Color.Color ) -> Html Msg
        square =
            paletteSquare
                model.picker.window.show
                model.picker.fields.index

        paletteSquares =
            model.palette
                |> Array.toIndexedList
                |> List.map square
    in
    div
        [ class [ Colors ]
        , style
            [ Util.height (Util.pbh - 10) ]
        ]
        (List.append paletteSquares [ addColor ])


addColor : Html Msg
addColor =
    div
        [ class [ Square, Plus ]
        , onClick AddPaletteSquare
        ]
        [ Html.text "+" ]


paletteSquare : Bool -> Int -> ( Int, Color.Color ) -> Html Msg
paletteSquare show selectedIndex ( index, color ) =
    let
        isSelected =
            index == selectedIndex
    in
    div
        [ class [ Square ]
        , background color
        , OpenColorPicker color index
            |> Util.onContextMenu
        , onClick (PaletteSquareClick color)
        ]
        (highLight (show && isSelected))


highLight : Bool -> List (Html Msg)
highLight show =
    if show then
        [ div
            [ class [ Selected ] ]
            []
        ]
    else
        []



-- SWATCHES --


swatchesView : Swatches -> Html msg
swatchesView { primary, first, second, third } =
    div
        [ class [ SwatchesContainer ] ]
        [ swatch primary Primary
        , swatch first First
        , swatch second Second
        , swatch third Third
        ]


swatch : Color.Color -> Class -> Html msg
swatch color quadrant =
    div
        [ class [ Swatch, quadrant ]
        , background color
        ]
        []
