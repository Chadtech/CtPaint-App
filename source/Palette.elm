module Palette exposing (..)

import Array exposing (Array)
import Color exposing (Color)
import Draw
import Html exposing (Attribute, Html, a, div, p, span, text)
import Html.Attributes exposing (class, classList, style)
import Html.Events exposing (onClick)
import Mouse exposing (Position)
import Tool exposing (Tool(..))
import Types exposing (Model, Msg(..))
import Util
    exposing
        ( (:=)
        , height
        , maybeCons
        , px
        , tbw
        , toColor
        , toHex
        )


-- INIT --


initPalette : Array Color
initPalette =
    [ Color.rgba 176 166 154 255
    , Color.black
    , Color.white
    , Color.rgba 241 29 35 255
    , Color.black
    , Color.black
    , Color.black
    , Color.black
    ]
        |> Array.fromList


initSwatches : Swatches
initSwatches =
    { primary = Color.rgba 176 166 154 255
    , first = Color.black
    , second = Color.white
    , third = Color.rgba 241 29 35 255
    , keyIsDown = False
    }



-- TYPES --


type alias Swatches =
    { primary : Color
    , first : Color
    , second : Color
    , third : Color
    , keyIsDown : Bool
    }



-- VIEW --


view : Model -> Html Msg
view model =
    div
        [ class "horizontal-tool-bar"
        , style
            [ height model.horizontalToolbarHeight ]
        ]
        [ edge
        , div
            [ class "palette" ]
            [ swatchesView model.swatches
            , generalPalette model
            ]
        , infoBox model
        ]



-- PALETTE --


generalPalette : Model -> Html Msg
generalPalette model =
    let
        square : Int -> Color -> Html Msg
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
        [ class "general"
        , style
            [ height (model.horizontalToolbarHeight - 10) ]
        ]
        (List.append paletteSquares [ addColor ])


addColor : Html Msg
addColor =
    div
        [ class "square plus"
        , onClick AddPaletteSquare
        ]
        [ text "+" ]


paletteSquare : Bool -> Int -> Int -> Color -> Html Msg
paletteSquare show selectedIndex index color =
    let
        isSelected =
            index == selectedIndex
    in
    div
        [ class "square"
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
            [ class "high-light" ]
            []
        ]
    else
        []



-- SWATCHES --


swatchesView : Swatches -> Html Msg
swatchesView { primary, first, second, third } =
    div
        [ class "swatches" ]
        [ swatch primary "primary"
        , swatch first "first"
        , swatch second "second"
        , swatch third "third"
        ]


swatch : Color -> String -> Html Msg
swatch color quadrant =
    div
        [ class ("swatch " ++ quadrant)
        , background color
        ]
        []



-- EDGE --


edge : Html Msg
edge =
    div
        [ class "edge" ]
        []



-- INFO BOX --


infoBox : Model -> Html Msg
infoBox model =
    div
        [ class "info-box"
        , style
            [ height (model.horizontalToolbarHeight - 10) ]
        ]
        (infoBoxContent model)


infoView : String -> Html Msg
infoView str =
    p [] [ text str ]


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
                    toHex color

                backgroundColor =
                    if (Color.toHsl color).lightness > 0.5 then
                        ""
                    else
                        "#ffffff"
            in
            [ p
                []
                [ text "color("
                , span
                    [ style
                        [ "color" := colorStr
                        , "background" := backgroundColor
                        ]
                    ]
                    [ text colorStr ]
                , text ")"
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


background : Color -> Attribute Msg
background =
    toHex
        >> (,) "background"
        >> List.singleton
        >> style


generalContent : Model -> List String
generalContent model =
    [ zoom model.zoom ]
        |> maybeCons (mouse model.mousePosition)


mouse : Maybe Position -> Maybe String
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
