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
import Data.Taco exposing (Taco)
import Helpers.Color
import Html exposing (Attribute, Html, a, div, p, span)
import Html.Attributes exposing (style)
import Html.CssHelpers
import Html.Custom
    exposing
        ( cannotSelect
        , indent
        , outdent
        )
import Html.Events exposing (on, onClick)
import Json.Decode as Decode exposing (Decoder)
import Mouse.Extra
import Ports
import Return2 as R2
import Tracking
    exposing
        ( Event
            ( PaletteAddSquareClick
            , PaletteSquareClick
            , PaletteSquareRightClick
            )
        )
import Util exposing (background, toHexColor)


-- TYPES --


type Msg
    = PaletteSquareClicked Int Color.Color Bool
    | PaletteSquareRightClicked Color.Color Int
    | AddPaletteSquareClicked



-- UPDATE --


update : Taco -> Msg -> Model -> ( Model, Cmd Msg )
update taco msg model =
    case msg of
        -- This bool represents if shift is down
        PaletteSquareClicked index color True ->
            PaletteSquareClick index (toHexColor color) True
                |> Ports.track taco
                |> R2.withModel
                    { model
                        | palette =
                            Array.set
                                index
                                model.swatches.top
                                model.palette
                    }

        PaletteSquareClicked index color False ->
            PaletteSquareClick index (toHexColor color) False
                |> Ports.track taco
                |> R2.withModel
                    { model
                        | swatches =
                            Helpers.Color.setTop
                                color
                                model.swatches
                    }

        PaletteSquareRightClicked color index ->
            PaletteSquareRightClick index (toHexColor color)
                |> Ports.track taco
                |> R2.withModel
                    { model
                        | picker =
                            { show = True
                            , index = index
                            , color = color
                            }
                                |> Picker.init
                    }

        AddPaletteSquareClicked ->
            PaletteAddSquareClick
                |> Ports.track taco
                |> R2.withModel
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
    | Top
    | Left
    | Bottom
    | Right
    | Colors
    | Square
    | Selected
    | Plus


squareSize : Float
squareSize =
    20


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
        , height (px squareSize)
        ]
    , Css.class Top
        [ top (px 0)
        , left (px 0)
        , width (px 98)
        ]
    , Css.class Left
        [ top (px 28)
        , left (px 0)
        , width (px squareSize)
        ]
    , Css.class Bottom
        [ top (px 28)
        , left (px 27)
        , width (px 44)
        ]
    , Css.class Right
        [ top (px 28)
        , left (px 78)
        , width (px squareSize)
        ]
    , (Css.class Colors << List.append indent)
        [ backgroundColor Ct.background2
        , width (calc (pct 100) minus (px 484))
        , position absolute
        , left (px 79)
        , top (px 4)
        , overflowY auto
        ]
    , (Css.class Square << List.append indent)
        [ height (px squareSize)
        , width (px squareSize)
        , display inlineBlock
        , float left
        , withClass Selected
            [ border3 (px 2) solid Ct.ignorable0
            , height (px squareSize)
            , width (px squareSize)
            ]
        ]
    , (Css.class Plus << List.append outdent << List.append cannotSelect)
        [ color Ct.point0
        , cursor pointer
        , active indent
        , fontFamilies [ "hfnss" ]
        , property "-webkit-font-smoothing" "none"
        , fontSize (em 2)
        , paddingTop (px 1)
        , height (px 19)
        , width (px squareSize)
        , backgroundColor Ct.ignorable2
        , textAlign center
        , lineHeight (px 19)
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
        , onClick AddPaletteSquareClicked
        ]
        [ Html.text "+" ]


square : Picker.Model -> ( Int, Color.Color ) -> Html Msg
square picker ( index, color ) =
    div
        [ class (squareClasses index picker)
        , background color
        , PaletteSquareRightClicked color index
            |> Mouse.Extra.onContextMenu
        , onClickWithShift (PaletteSquareClicked index color)
        ]
        []


squareIsSelected : Int -> Picker.Model -> Bool
squareIsSelected index picker =
    index == picker.index && picker.show


onClickWithShift : (Bool -> Msg) -> Attribute Msg
onClickWithShift toMsg =
    on "click" (Decode.map toMsg shiftDecoder)


shiftDecoder : Decoder Bool
shiftDecoder =
    Decode.field "shiftKey" Decode.bool


squareClasses : Int -> Picker.Model -> List Class
squareClasses index picker =
    if squareIsSelected index picker then
        [ Square, Selected ]
    else
        [ Square ]



-- SWATCHES --


swatchesView : Swatches -> Html msg
swatchesView { top, left, bottom, right } =
    div
        [ class [ SwatchesContainer ] ]
        [ swatch top Top
        , swatch left Left
        , swatch bottom Bottom
        , swatch right Right
        ]


swatch : Color.Color -> Class -> Html msg
swatch color quadrant =
    div
        [ class [ Swatch, quadrant ]
        , background color
        ]
        []
