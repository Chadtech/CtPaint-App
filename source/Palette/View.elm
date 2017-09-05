module Palette.View exposing (..)

import Array
import Color exposing (Color)
import Draw.Util exposing (colorAt)
import ElementRelativeMouseEvents as Events
import Html exposing (Attribute, Html, a, div, p, span, text)
import Html.Attributes exposing (class, classList, style)
import Html.Events exposing (onClick)
import Main.Model exposing (Model)
import Mouse exposing (Position)
import Palette.Types as Palette exposing (Message(..), Swatches)
import Tool.Types exposing (Tool(..))
import Types.Mouse exposing (Direction(..))
import Util exposing ((:=), height, maybeCons, px, tbw)


view : Model -> Html Message
view model =
    div
        [ class "horizontal-tool-bar"
        , style
            [ height model.horizontalToolbarHeight ]
        ]
        [ edge
        , div
            [ class "palette" ]
            [ swatches model.swatches
            , generalPalette model
            ]
        , infoBox model
        ]



-- PALETTE --


generalPalette : Model -> Html Message
generalPalette model =
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



-- EDGE --


edge : Html Message
edge =
    div
        [ class "edge"
        , Util.toPosition
            >> Down
            >> ResizeToolbar
            |> Events.onMouseDown
        , Util.toPosition
            >> Up
            >> ResizeToolbar
            |> Events.onMouseUp
        ]
        []



-- INFO BOX --


infoBox : Model -> Html Message
infoBox model =
    div
        [ class "info-box"
        , style
            [ height (model.horizontalToolbarHeight - 10) ]
        ]
        (infoBoxContent model)


infoView : String -> Html Message
infoView str =
    p [] [ text str ]


infoBoxContent : Model -> List (Html Message)
infoBoxContent model =
    [ List.map infoView (toolContent model)
    , List.map infoView (generalContent model)
    , sampleColor model
    ]
        |> List.concat


sampleColor : Model -> List (Html Message)
sampleColor model =
    case model.mousePosition of
        Just position ->
            let
                color =
                    colorAt
                        position
                        model.canvas

                colorStr =
                    Palette.toHex color

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


background : Color -> Attribute Message
background =
    Palette.toHex
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
