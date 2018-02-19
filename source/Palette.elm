module Palette
    exposing
        ( Msg
        , css
        , paletteView
        , swatchesView
        , update
        )

import Array exposing (Array)
import Chadtech.Colors as Ct
import Color exposing (Color)
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Color exposing (Model, Swatches)
import Data.Picker as Picker
import Helpers.Color
import Html exposing (Attribute, Html, a, div, p, span)
import Html.Attributes exposing (class, classList, style)
import Html.CssHelpers
import Html.Custom exposing (cannotSelect, indent, outdent)
import Html.Events exposing (on, onClick)
import Json.Decode as Decode exposing (Decoder)
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
    = PaletteSquareClick Int Color.Color Bool
    | OpenColorPicker Color.Color Int
    | AddPaletteSquare



-- UPDATE --


update : Msg -> Model -> Model
update msg model =
    case msg of
        PaletteSquareClick index color shift ->
            if shift then
                { model
                    | palette =
                        Array.set
                            index
                            model.swatches.top
                            model.palette
                }
            else
                { model
                    | swatches =
                        Helpers.Color.setTop
                            color
                            model.swatches
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
                        model.swatches.bottom
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
        [ backgroundColor Ct.background2
        , width (calc (pct 100) minus (px 484))
        , position absolute
        , left (px 79)
        , top (px 4)
        , overflowY auto
        ]
    , (Css.class Square << List.append outdent)
        [ height (px 20)
        , width (px 20)
        , display inlineBlock
        , float left
        , withClass Selected
            [ border3 (px 2) solid Ct.ignorable0
            , height (px 18)
            , width (px 18)
            ]
        ]
    , (Css.class Plus << List.append outdent << List.append cannotSelect)
        [ color Ct.point0
        , cursor pointer
        , active indent
        , fontFamilies [ "hfnss" ]
        , property "-webkit-font-smoothing" "none"
        , fontSize (em 2)
        , height (px 18)
        , width (px 18)
        , backgroundColor Ct.ignorable2
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
    div
        [ class [ Colors ]
        , style
            [ Util.height (Util.pbh - 10) ]
        ]
        (List.append (squares model) [ addColor ])


squares : Model -> List (Html Msg)
squares { picker, palette } =
    palette
        |> Array.toIndexedList
        |> List.map (square picker)


addColor : Html Msg
addColor =
    div
        [ class [ Square, Plus ]
        , onClick AddPaletteSquare
        ]
        [ Html.text "+" ]


square : Picker.Model -> ( Int, Color.Color ) -> Html Msg
square picker ( index, color ) =
    let
        isSelected =
            index == picker.fields.index

        shown =
            picker.window.show
    in
    div
        [ class (squareClasses (isSelected && shown))
        , background color
        , OpenColorPicker color index
            |> Util.onContextMenu
        , onClickWithShift (PaletteSquareClick index color)
        ]
        []


onClickWithShift : (Bool -> Msg) -> Attribute Msg
onClickWithShift toMsg =
    on "click" (Decode.map toMsg shiftDecoder)


shiftDecoder : Decoder Bool
shiftDecoder =
    Decode.field "shiftKey" Decode.bool


squareClasses : Bool -> List Class
squareClasses show =
    if show then
        [ Square, Selected ]
    else
        [ Square ]



-- SWATCHES --


swatchesView : Swatches -> Html msg
swatchesView { top, left, bottom, right } =
    div
        [ class [ SwatchesContainer ] ]
        [ swatch top Primary
        , swatch left First
        , swatch bottom Second
        , swatch right Third
        ]


swatch : Color.Color -> Class -> Html msg
swatch color quadrant =
    div
        [ class [ Swatch, quadrant ]
        , background color
        ]
        []
