module Scale exposing (..)

import Html exposing (Html, a, div, form, input, p, text)
import Html.Attributes exposing (class, placeholder)
import Html.Events exposing (onSubmit)
import Util exposing ((&))
import Window exposing (Size)


-- TYPES --


type alias Model =
    { fixedWidth : Int
    , fixedHeight : Int
    , percentWidth : Float
    , percentHeight : Float
    , initialSize : Size
    , lockRatio : Bool
    }


type ExternalMsg
    = DoNothing
    | ScaleTo Int Int


type Msg
    = UpdateField Field String
    | ScaleClick


type Field
    = FixedWidth
    | FixedHeight
    | PercentWidth
    | PercentHeight



-- VIEW --


view : Model -> List (Html Msg)
view model =
    [ div
        [ class "select-body" ]
        [ leftSide model
        , rightSide model
        , form
            [ class "field ratio" ]
            [ p [] [ text "Lock" ]
            , input [] []
            ]
        , div
            [ class "buttons-container" ]
            [ a
                []
                [ text "Set Size" ]
            , a
                []
                [ text "Cancel" ]
            ]
        ]
    ]


rightSide : Model -> Html Msg
rightSide { initialSize } =
    div
        [ class "column" ]
        [ p [] [ text "Percent" ]
        , field
            [ p [] [ text "width" ]
            , input
                [ placeholder "100%" ]
                []
            ]
        , field
            [ p [] [ text "height" ]
            , input
                [ placeholder "100%" ]
                []
            ]
        ]


leftSide : Model -> Html Msg
leftSide { initialSize } =
    div
        [ class "column" ]
        [ p [] [ text "Percent" ]
        , field
            [ p [] [ text "width" ]
            , input
                [ placeholder "100%" ]
                []
            ]
        , field
            [ p [] [ text "height" ]
            , input
                [ placeholder "100%" ]
                []
            ]
        ]


field : List (Html Msg) -> Html Msg
field =
    form
        [ class "field scale"
        , onSubmit ScaleClick
        ]



-- UPDATE --


update : Msg -> Model -> ( Model, ExternalMsg )
update msg model =
    case msg of
        UpdateField field str ->
            updateField field str model

        ScaleClick ->
            let
                { fixedWidth, fixedHeight } =
                    model
            in
            model & ScaleTo fixedWidth fixedHeight


updateField : Field -> String -> Model -> ( Model, ExternalMsg )
updateField field str model =
    case field of
        FixedWidth ->
            case String.toInt str of
                Ok fixedWidth ->
                    handleFixedWidth fixedWidth model

                Err err ->
                    model & DoNothing

        FixedHeight ->
            case String.toInt str of
                Ok fixedHeight ->
                    handleFixedHeight fixedHeight model

                Err err ->
                    model & DoNothing

        PercentWidth ->
            case String.toFloat str of
                Ok percentWidth ->
                    handlePercentWidth percentWidth model

                Err err ->
                    model & DoNothing

        PercentHeight ->
            case String.toFloat str of
                Ok percentHeight ->
                    handlePercentHeight percentHeight model

                Err err ->
                    model & DoNothing


handleFixedWidth : Int -> Model -> ( Model, ExternalMsg )
handleFixedWidth fixedWidth model =
    { model
        | fixedWidth = fixedWidth
        , percentWidth =
            let
                fixedWidth_ =
                    toFloat fixedWidth

                initialWidth =
                    toFloat model.initialSize.width
            in
            fixedWidth_ / initialWidth
    }
        & DoNothing


handleFixedHeight : Int -> Model -> ( Model, ExternalMsg )
handleFixedHeight fixedHeight model =
    { model
        | fixedHeight = fixedHeight
        , percentHeight =
            let
                fixedHeight_ =
                    toFloat fixedHeight

                initialHeight =
                    toFloat model.initialSize.height
            in
            fixedHeight_ / initialHeight
    }
        & DoNothing


handlePercentWidth : Float -> Model -> ( Model, ExternalMsg )
handlePercentWidth percentWidth model =
    { model
        | percentWidth = percentWidth
        , fixedWidth =
            let
                initialWidth =
                    toFloat model.initialSize.width
            in
            round (initialWidth * (percentWidth / 100))
    }
        & DoNothing


handlePercentHeight : Float -> Model -> ( Model, ExternalMsg )
handlePercentHeight percentHeight model =
    { model
        | percentHeight = percentHeight
        , fixedHeight =
            let
                initialHeight =
                    toFloat model.initialSize.height
            in
            round (initialHeight * (percentHeight / 100))
    }
        & DoNothing



-- INIT --


init : Size -> Model
init size =
    { fixedWidth = size.width
    , fixedHeight = size.height
    , percentWidth = 100
    , percentHeight = 100
    , initialSize = size
    , lockRatio = False
    }
