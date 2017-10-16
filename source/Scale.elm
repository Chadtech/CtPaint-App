module Scale exposing (..)

import Html
    exposing
        ( Attribute
        , Html
        , a
        , div
        , form
        , input
        , p
        , text
        )
import Html.Attributes
    exposing
        ( class
        , placeholder
        , type_
        , value
        )
import Html.Events
    exposing
        ( onClick
        , onFocus
        , onInput
        , onSubmit
        )
import Util exposing ((&), pct, px)
import Window exposing (Size)


-- TYPES --


type alias Model =
    { fixedWidth : Int
    , fixedHeight : Int
    , percentWidth : Float
    , percentHeight : Float
    , fixedWidthField : String
    , fixedHeightField : String
    , percentWidthField : String
    , percentHeightField : String
    , initialSize : Size
    , lockRatio : Bool
    , focus : Maybe Field
    }


type ExternalMsg
    = DoNothing
    | ScaleTo Int Int


type Msg
    = UpdateField Field String
    | Lock
    | FieldFocused Field
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
        , div
            []
            [ lock model.lockRatio
            ]
        , a
            [ class "submit-button"
            , onClick ScaleClick
            ]
            [ text "set size" ]
        ]
    ]


lock : Bool -> Html Msg
lock locked =
    form
        [ class "field scale lock" ]
        [ p [] [ text "lock" ]
        , input
            [ class "ratio-lock"
            , lockedValue locked
            , onClick Lock
            , type_ "button"
            ]
            []
        ]


lockedValue : Bool -> Attribute Msg
lockedValue locked =
    if locked then
        value "x"
    else
        value " "


leftSide : Model -> Html Msg
leftSide model =
    div
        [ class "column" ]
        [ p [] [ text "percent" ]
        , field
            [ p [] [ text "width" ]
            , input
                [ placeholder (pct model.percentWidth)
                , onFocus (FieldFocused PercentWidth)
                , valueIfFocus
                    PercentWidth
                    model.focus
                    model.percentWidthField
                , onInput (UpdateField PercentWidth)
                ]
                []
            ]
        , field
            [ p [] [ text "height" ]
            , input
                [ placeholder (pct model.percentHeight)
                , onFocus (FieldFocused PercentHeight)
                , valueIfFocus
                    PercentHeight
                    model.focus
                    model.percentHeightField
                , onInput (UpdateField PercentHeight)
                ]
                []
            ]
        ]


valueIfFocus : Field -> Maybe Field -> String -> Attribute Msg
valueIfFocus thisField maybeFocusedField str =
    case maybeFocusedField of
        Just focusedField ->
            if thisField == focusedField then
                value str
            else
                value ""

        Nothing ->
            value ""


rightSide : Model -> Html Msg
rightSide model =
    div
        [ class "column" ]
        [ p [] [ text "absolute" ]
        , field
            [ p [] [ text "width" ]
            , input
                [ placeholder (px model.fixedWidth)
                , onFocus (FieldFocused FixedWidth)
                , valueIfFocus
                    FixedWidth
                    model.focus
                    model.fixedWidthField
                , onInput (UpdateField FixedWidth)
                ]
                []
            ]
        , field
            [ p [] [ text "height" ]
            , input
                [ placeholder (px model.fixedHeight)
                , onFocus (FieldFocused FixedHeight)
                , valueIfFocus
                    FixedHeight
                    model.focus
                    model.fixedHeightField
                , onInput (UpdateField FixedHeight)
                ]
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

        Lock ->
            { model
                | lockRatio =
                    not model.lockRatio
            }
                & DoNothing

        FieldFocused field ->
            { model
                | focus = Just field
            }
                & DoNothing

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
            let
                newModel =
                    { model
                        | fixedWidthField = str
                    }
            in
            case String.toInt str of
                Ok fixedWidth ->
                    cohereFixedWidth fixedWidth newModel

                Err err ->
                    newModel & DoNothing

        FixedHeight ->
            let
                newModel =
                    { model
                        | fixedHeightField = str
                    }
            in
            case String.toInt str of
                Ok fixedHeight ->
                    cohereFixedHeight fixedHeight newModel

                Err err ->
                    newModel & DoNothing

        PercentWidth ->
            let
                newModel =
                    { model
                        | percentWidthField = str
                    }
            in
            case String.toFloat str of
                Ok percentWidth ->
                    coherePercentWidth percentWidth newModel

                Err err ->
                    newModel & DoNothing

        PercentHeight ->
            let
                newModel =
                    { model
                        | percentHeightField = str
                    }
            in
            case String.toFloat str of
                Ok percentHeight ->
                    coherePercentHeight percentHeight newModel

                Err err ->
                    newModel & DoNothing


cohereFixedWidth : Int -> Model -> ( Model, ExternalMsg )
cohereFixedWidth fixedWidth model =
    { model
        | fixedWidth = fixedWidth
        , percentWidth =
            let
                fixedWidth_ =
                    toFloat fixedWidth

                initialWidth =
                    toFloat model.initialSize.width
            in
            (fixedWidth_ / initialWidth) * 100
    }
        & DoNothing


cohereFixedHeight : Int -> Model -> ( Model, ExternalMsg )
cohereFixedHeight fixedHeight model =
    { model
        | fixedHeight = fixedHeight
        , percentHeight =
            let
                fixedHeight_ =
                    toFloat fixedHeight

                initialHeight =
                    toFloat model.initialSize.height
            in
            (fixedHeight_ / initialHeight) * 100
    }
        & DoNothing


coherePercentWidth : Float -> Model -> ( Model, ExternalMsg )
coherePercentWidth percentWidth model =
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


coherePercentHeight : Float -> Model -> ( Model, ExternalMsg )
coherePercentHeight percentHeight model =
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
    , fixedWidthField = toString size.width
    , fixedHeightField = toString size.height
    , percentWidthField = "100"
    , percentHeightField = "100"
    , initialSize = size
    , lockRatio = False
    , focus = Nothing
    }
