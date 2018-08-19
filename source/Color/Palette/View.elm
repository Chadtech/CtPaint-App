module Color.Palette.View
    exposing
        ( css
        , view
        )

import Array exposing (Array)
import Chadtech.Colors as Ct
import Color exposing (Color)
import Color.Model exposing (Model)
import Color.Palette.Msg exposing (Msg(..))
import Color.Picker.Data exposing (Picker)
import Color.Style exposing (paletteSquareSize)
import Color.Util
import Css exposing (..)
import Css.Namespace exposing (namespace)
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
import Html.Mouse
import Json.Decode as Decode exposing (Decoder)
import Style
import Util


-- STYLES --


type Class
    = Colors
    | Square
    | Selected
    | Plus


css : Stylesheet
css =
    [ (Css.class Colors << List.append indent)
        [ backgroundColor Ct.background2
        , width (calc (pct 100) minus (px 484))
        , position absolute
        , left (px 79)
        , top (px 4)
        , overflowY auto
        ]
    , (Css.class Square << List.append indent)
        [ height (px paletteSquareSize)
        , width (px paletteSquareSize)
        , display inlineBlock
        , float left
        , withClass Selected
            [ border3 (px 2) solid Ct.ignorable0
            , height (px paletteSquareSize)
            , width (px paletteSquareSize)
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
        , width (px paletteSquareSize)
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


view : Model -> Html Msg
view model =
    div
        [ class [ Colors ]
        , style
            [ Util.height (Style.palettebarHeight - 10) ]
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
        , onClick AddSquareClicked
        ]
        [ Html.text "+" ]


square : Picker -> ( Int, Color.Color ) -> Html Msg
square picker ( index, color ) =
    div
        [ class (squareClasses index picker)
        , Color.Util.background color
        , SquareRightClicked color index
            |> Html.Mouse.onContextMenu
        , onClickWithShift (SquareClicked index color)
        ]
        []


squareIsSelected : Int -> Picker -> Bool
squareIsSelected index picker =
    picker.show && index == picker.colorIndex


onClickWithShift : (Bool -> Msg) -> Attribute Msg
onClickWithShift toMsg =
    on "click" (Decode.map toMsg shiftDecoder)


shiftDecoder : Decoder Bool
shiftDecoder =
    Decode.field "shiftKey" Decode.bool


squareClasses : Int -> Picker -> List Class
squareClasses index picker =
    if squareIsSelected index picker then
        [ Square, Selected ]
    else
        [ Square ]
