module Scale exposing (..)

import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
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
import Html.CssHelpers
import Html.Custom
import Html.Events
    exposing
        ( onClick
        , onFocus
        , onInput
        , onSubmit
        )
import Reply exposing (Reply(NoReply, ScaleTo))
import Tuple.Infix exposing ((&))
import Util
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


type Msg
    = FieldUpdated Field String
    | LockButtonClicked
    | FieldFocused Field
    | ScaleClick


type Field
    = FixedWidth
    | FixedHeight
    | PercentWidth
    | PercentHeight



-- STYLES --


type Class
    = Lock
    | LockContainer
    | Field
    | Row


css : Stylesheet
css =
    [ Css.class LockContainer
        [ display inlineBlock
        , children
            [ Css.Elements.p
                [ display inlineBlock
                , width (px 120)
                ]
            ]
        ]
    , Css.class Field
        [ margin4 (px 4) (px 0) (px 0) (px 0)
        , children
            [ Css.Elements.input
                [ width (px 80) ]
            , Css.Elements.p
                [ width (px 80) ]
            ]
        ]
    , Css.class Lock
        [ width (px 24)
        , height (px 24)
        , borderRadius (px 0)
        , paddingBottom (px 2)
        , cursor pointer
        , textAlign center
        , marginBottom (px 8)
        , children
            [ Css.Elements.input
                [ width auto ]
            ]
        ]
    , Css.class Row
        [ marginBottom (px 8)
        , marginRight (px 8)
        ]
    ]
        |> namespace scaleNamespace
        |> stylesheet


scaleNamespace : String
scaleNamespace =
    Html.Custom.makeNamespace "Scale"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace scaleNamespace


view : Model -> List (Html Msg)
view model =
    [ percentScaling model
    , absoluteScaling model
    , div
        []
        [ lock model.lockRatio
        ]
    , Html.Custom.menuButton
        [ onClick ScaleClick ]
        [ Html.text "set size" ]
    ]


lock : Bool -> Html Msg
lock locked =
    form
        [ class [ Field, LockContainer ] ]
        [ p [] [ Html.text "lock" ]
        , input
            [ class [ Lock ]
            , lockedValue locked
            , onClick LockButtonClicked
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


percentScaling : Model -> Html Msg
percentScaling model =
    div
        [ class [ Row ] ]
        [ p [] [ Html.text "percent" ]
        , field
            [ p [] [ Html.text "width" ]
            , input
                [ placeholder (Util.pct model.percentWidth)
                , onFocus (FieldFocused PercentWidth)
                , valueIfFocus
                    PercentWidth
                    model.focus
                    model.percentWidthField
                , onInput (FieldUpdated PercentWidth)
                ]
                []
            ]
        , field
            [ p [] [ Html.text "height" ]
            , input
                [ placeholder (Util.pct model.percentHeight)
                , onFocus (FieldFocused PercentHeight)
                , valueIfFocus
                    PercentHeight
                    model.focus
                    model.percentHeightField
                , onInput (FieldUpdated PercentHeight)
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


absoluteScaling : Model -> Html Msg
absoluteScaling model =
    div
        [ class [ Row ] ]
        [ p [] [ Html.text "absolute" ]
        , field
            [ p [] [ Html.text "width" ]
            , input
                [ placeholder (Util.px model.fixedWidth)
                , onFocus (FieldFocused FixedWidth)
                , valueIfFocus
                    FixedWidth
                    model.focus
                    model.fixedWidthField
                , onInput (FieldUpdated FixedWidth)
                ]
                []
            ]
        , field
            [ p [] [ Html.text "height" ]
            , input
                [ placeholder (Util.px model.fixedHeight)
                , onFocus (FieldFocused FixedHeight)
                , valueIfFocus
                    FixedHeight
                    model.focus
                    model.fixedHeightField
                , onInput (FieldUpdated FixedHeight)
                ]
                []
            ]
        ]


field : List (Html Msg) -> Html Msg
field =
    Html.Custom.field
        [ class [ Field ]
        , onSubmit ScaleClick
        ]



-- UPDATE --


update : Msg -> Model -> ( Model, Reply )
update msg model =
    case msg of
        FieldUpdated field str ->
            updateField field str model & NoReply

        LockButtonClicked ->
            { model
                | lockRatio =
                    not model.lockRatio
            }
                & NoReply

        FieldFocused field ->
            { model
                | focus = Just field
            }
                & NoReply

        ScaleClick ->
            let
                { fixedWidth, fixedHeight } =
                    model
            in
            model & ScaleTo fixedWidth fixedHeight


updateField : Field -> String -> Model -> Model
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
                    newModel

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
                    newModel

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
                    newModel

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
                    newModel


cohereFixedWidth : Int -> Model -> Model
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


cohereFixedHeight : Int -> Model -> Model
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


coherePercentWidth : Float -> Model -> Model
coherePercentWidth percentWidth model =
    { model
        | percentWidth = percentWidth
        , fixedWidth =
            let
                initialWidth =
                    toFloat model.initialSize.width
            in
            Basics.round (initialWidth * (percentWidth / 100))
    }


coherePercentHeight : Float -> Model -> Model
coherePercentHeight percentHeight model =
    { model
        | percentHeight = percentHeight
        , fixedHeight =
            let
                initialHeight =
                    toFloat model.initialSize.height
            in
            Basics.round (initialHeight * (percentHeight / 100))
    }



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
