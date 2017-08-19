module Toolbar.Horizontal.View exposing (..)

import Html exposing (Html, div, p, a, span, text)
import Html.Attributes exposing (class, style)
import Main.Model exposing (Model)
import ElementRelativeMouseEvents as Events
import Toolbar.Horizontal.Types exposing (Message(..))
import Util exposing ((:=), tbw, height, maybeCons)
import Types.Mouse exposing (Direction(..))
import Palette.View as Palette
import Mouse exposing (Position)
import Tool.Types exposing (Tool(..))
import Draw.Util exposing (colorAt)
import Palette.Types as Palette


view : Model -> Html Message
view model =
    div
        [ class "horizontal-tool-bar"
        , style
            [ height model.horizontalToolbarHeight ]
        ]
        [ edge
        , Palette.view model
        , infoBox model
        ]


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
                color : String
                color =
                    colorAt
                        position
                        model.canvas
                        |> Palette.toHex
            in
                [ p
                    []
                    [ text "color("
                    , span
                        [ style
                            [ "color" := color ]
                        ]
                        [ text color ]
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


generalContent : Model -> List String
generalContent model =
    [ zoom model.zoom ]
        |> maybeCons (mouse model.mousePosition)


mouse : Maybe Position -> Maybe String
mouse maybePosition =
    case maybePosition of
        Just { x, y } ->
            [ "mouse(" ++ (toString x)
            , "," ++ (toString y)
            , ")"
            ]
                |> String.concat
                |> Just

        Nothing ->
            Nothing


zoom : Int -> String
zoom z =
    "zoom(" ++ (toString (z * 100)) ++ "%)"
