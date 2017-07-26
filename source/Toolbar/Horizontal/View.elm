module Toolbar.Horizontal.View exposing (..)

import Html exposing (Html, div, p, a, text)
import Html.Attributes exposing (class, style)
import Main.Model exposing (Model)
import ElementRelativeMouseEvents as Events
import Toolbar.Horizontal.Types exposing (Message(..))
import Util exposing ((:=), height)
import Types.Mouse exposing (Direction(..))
import Palette.View as Palette
import Mouse exposing (Position)


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
        (List.map infoView (infoBoxContent model))


infoView : String -> Html Message
infoView str =
    p [] [ text str ]


infoBoxContent : Model -> List String
infoBoxContent model =
    List.concat
        [ generalContent model
        ]


generalContent : Model -> List String
generalContent model =
    [ mouse model.mousePosition
    , [ zoom model.zoom ]
    ]
        |> List.concat
        |> List.map (\str -> (str ++ ", "))


mouse : Maybe Position -> List String
mouse maybePosition =
    case maybePosition of
        Just { x, y } ->
            [ "x = " ++ (toString x)
            , "y = " ++ (toString y)
            ]

        Nothing ->
            []


zoom : Int -> String
zoom z =
    "zoom = " ++ (toString (z * 100)) ++ "%"
