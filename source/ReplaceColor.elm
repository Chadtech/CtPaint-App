module ReplaceColor exposing (..)

import Color exposing (Color)
import Html exposing (Html, a, div, p, text)
import Html.Attributes exposing (class, style)
import Html.Events exposing (onClick)
import Util exposing ((&), background, height)


type Msg
    = OkayClick
    | ChangeReplacementTo Color


type ExternalMsg
    = DoNothing
    | Replace Color Color


type alias Model =
    { target : Color
    , replacement : Color
    , palette : List Color
    }



-- UPDATE --


update : Msg -> Model -> ( Model, ExternalMsg )
update msg model =
    case msg of
        OkayClick ->
            model & Replace model.target model.replacement

        ChangeReplacementTo color ->
            { model | replacement = color }
                & DoNothing



-- VIEW --


view : Model -> List (Html Msg)
view model =
    [ div
        [ class "select-body" ]
        [ div
            [ class "color-row" ]
            [ p [] [ text "replace" ]
            , colorView model.target
            ]
        , div
            [ class "color-row" ]
            [ p [] [ text "with" ]
            , colorView model.replacement
            ]
        , div
            [ class "replace-palette" ]
            (squares model.palette)
        , a
            [ class "submit-button"
            , onClick OkayClick
            ]
            [ text "replace" ]
        ]
    ]


squares : List Color -> List (Html Msg)
squares =
    List.map square


square : Color -> Html Msg
square color =
    div
        [ class "square"
        , onClick (ChangeReplacementTo color)
        , background color
        ]
        []


colorView : Color -> Html Msg
colorView color =
    div
        [ class "color-view"
        , background color
        ]
        []



-- INIT --


init : Color -> Color -> List Color -> Model
init target replacement palette =
    { target = target
    , replacement = replacement
    , palette = palette
    }
