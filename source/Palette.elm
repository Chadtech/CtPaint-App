module Palette exposing (Msg, css, update, view)

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
import ColorPicker
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Palette exposing (Swatches)
import Data.Tool exposing (Tool(..))
import Draw
import Html exposing (Attribute, Html, a, div, p, span)
import Html.Attributes exposing (class, classList, style)
import Html.CssHelpers
import Html.Custom exposing (cannotSelect, indent, outdent)
import Html.Events exposing (onClick)
import Model exposing (Model)
import Mouse
import Tuple.Infix exposing ((:=))
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
            let
                { swatches } =
                    model
            in
            { model
                | swatches =
                    { swatches
                        | primary = color
                    }
            }

        OpenColorPicker color index ->
            { model
                | colorPicker =
                    ColorPicker.init True index color
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
    = Palette
    | SwatchesContainer
    | Swatch
    | Primary
    | First
    | Second
    | Third
    | Colors
    | Square
    | Selected
    | Plus
    | Edge
    | Info


css : Stylesheet
css =
    [ Css.class Palette
        [ backgroundColor ignorable2
        , position fixed
        , bottom (px 0)
        , left (px toolbarWidth)
        , width (calc (pct 100) minus (px 29))
        ]
    , Css.class SwatchesContainer
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
        , width (px 74)
        ]
    , Css.class First
        [ top (px 28)
        , left (px 0)
        , width (px 20)
        ]
    , Css.class Second
        [ top (px 28)
        , left (px 27)
        , width (px 20)
        ]
    , Css.class Third
        [ top (px 28)
        , left (px 54)
        , width (px 20)
        ]
    , (Css.class Colors << List.append indent)
        [ backgroundColor backgroundx2
        , width (calc (pct 100) minus (px 360))
        , position absolute
        , left (px 55)
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
    , (Css.class Info << List.append indent)
        [ backgroundColor backgroundx2
        , width (px 290)
        , position absolute
        , left (calc (pct 100) minus (px 297))
        , top (px 4)
        , overflowY auto
        ]
    , Css.class Edge
        [ height (px 3)
        , borderTop3 (px 2) solid ignorable1
        , top (px 0)
        , left (px 0)
        , cursor nsResize
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


view : Model -> Html Msg
view model =
    div
        [ class [ Palette ]
        , style [ Util.height model.horizontalToolbarHeight ]
        ]
        [ edge
        , swatchesView model.swatches
        , generalPalette model
        , infoBox model
        ]



-- PALETTE --


generalPalette : Model -> Html Msg
generalPalette model =
    let
        square : Int -> Color.Color -> Html Msg
        square =
            paletteSquare
                model.colorPicker.window.show
                model.colorPicker.picker.index

        paletteSquares =
            model.palette
                |> Array.indexedMap square
                |> Array.toList
    in
    div
        [ class [ Colors ]
        , style
            [ Util.height (model.horizontalToolbarHeight - 10) ]
        ]
        (List.append paletteSquares [ addColor ])


addColor : Html Msg
addColor =
    div
        [ class [ Square, Plus ]
        , onClick AddPaletteSquare
        ]
        [ Html.text "+" ]


paletteSquare : Bool -> Int -> Int -> Color.Color -> Html Msg
paletteSquare show selectedIndex index color =
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


swatchesView : Swatches -> Html Msg
swatchesView { primary, first, second, third } =
    div
        [ class [ SwatchesContainer ] ]
        [ swatch primary Primary
        , swatch first First
        , swatch second Second
        , swatch third Third
        ]


swatch : Color.Color -> Class -> Html Msg
swatch color quadrant =
    div
        [ class [ Swatch, quadrant ]
        , background color
        ]
        []



-- EDGE --


edge : Html Msg
edge =
    div [ class [ Edge ] ] []



-- INFO BOX --


infoBox : Model -> Html Msg
infoBox model =
    div
        [ class [ Info ]
        , style
            [ Util.height (model.horizontalToolbarHeight - 10) ]
        ]
        (infoBoxContent model)


infoView : String -> Html Msg
infoView str =
    p [] [ Html.text str ]


infoBoxContent : Model -> List (Html Msg)
infoBoxContent model =
    [ List.map infoView (toolContent model)
    , List.map infoView (generalContent model)
    , sampleColor model
    ]
        |> List.concat


sampleColor : Model -> List (Html Msg)
sampleColor model =
    case model.mousePosition of
        Just position ->
            let
                color =
                    Draw.colorAt
                        position
                        model.canvas

                colorStr =
                    Util.toHexColor color

                backgroundColor =
                    if (Color.toHsl color).lightness > 0.5 then
                        ""
                    else
                        "#ffffff"
            in
            [ p
                []
                [ Html.text "color("
                , span
                    [ style
                        [ "color" := colorStr
                        , "background" := backgroundColor
                        ]
                    ]
                    [ Html.text colorStr ]
                , Html.text ")"
                ]
            ]

        Nothing ->
            []


toolContent : Model -> List String
toolContent ({ tool } as model) =
    case tool of
        Select maybePosition ->
            case ( maybePosition, model.mousePosition ) of
                ( Just origin, Just position ) ->
                    let
                        size =
                            [ "rect("
                            , (origin.x - position.x + 1)
                                |> abs
                                |> toString
                            , ","
                            , (origin.y - position.y + 1)
                                |> abs
                                |> toString
                            , ")"
                            ]

                        originStr =
                            [ "origin("
                            , toString origin.x
                            , ","
                            , toString origin.y
                            , ")"
                            ]
                    in
                    [ size
                    , originStr
                    ]
                        |> List.map String.concat

                _ ->
                    []

        Rectangle maybePosition ->
            case ( maybePosition, model.mousePosition ) of
                ( Just origin, Just position ) ->
                    let
                        size =
                            [ "rect("
                            , (origin.x - position.x + 1)
                                |> abs
                                |> toString
                            , ","
                            , (origin.y - position.y + 1)
                                |> abs
                                |> toString
                            , ")"
                            ]

                        originStr =
                            [ "origin("
                            , toString origin.x
                            , ","
                            , toString origin.y
                            , ")"
                            ]
                    in
                    [ size
                    , originStr
                    ]
                        |> List.map String.concat

                _ ->
                    []

        RectangleFilled maybePosition ->
            case ( maybePosition, model.mousePosition ) of
                ( Just origin, Just position ) ->
                    let
                        size =
                            [ "rect("
                            , (origin.x - position.x + 1)
                                |> abs
                                |> toString
                            , ","
                            , (origin.y - position.y + 1)
                                |> abs
                                |> toString
                            , ")"
                            ]

                        originStr =
                            [ "origin("
                            , toString origin.x
                            , ","
                            , toString origin.y
                            , ")"
                            ]
                    in
                    [ size
                    , originStr
                    ]
                        |> List.map String.concat

                _ ->
                    []

        _ ->
            []



-- HELPERS --


generalContent : Model -> List String
generalContent model =
    [ zoom model.zoom ]
        |> maybeCons (mouse model.mousePosition)


mouse : Maybe Mouse.Position -> Maybe String
mouse maybePosition =
    case maybePosition of
        Just { x, y } ->
            [ "mouse(" ++ toString x
            , "," ++ toString y
            , ")"
            ]
                |> String.concat
                |> Just

        Nothing ->
            Nothing


zoom : Int -> String
zoom z =
    "zoom(" ++ toString (z * 100) ++ "%)"
