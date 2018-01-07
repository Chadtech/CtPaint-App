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
                [ width (px 80)
                , withClass Lock
                    [ width (px 24) ]
                ]
            , Css.Elements.p
                [ width (px 80) ]
            ]
        ]
    , Css.class Lock
        [ height (px 24)
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
            { model | fixedWidthField = str }
                |> parseFixedWidth

        FixedHeight ->
            { model | fixedHeightField = str }
                |> parseFixedHeight

        PercentWidth ->
            { model | percentWidthField = str }
                |> parsePercentWidth

        PercentHeight ->
            { model | percentHeightField = str }
                |> parsePercentHeight


parseFixedWidth : Model -> Model
parseFixedWidth model =
    case String.toInt model.fixedWidthField of
        Ok fixedWidth ->
            { model | fixedWidth = fixedWidth }
                |> percentWidthFromFixedWidth
                |> heightFromFixedWidth

        Err err ->
            model


percentWidthFromFixedWidth : Model -> Model
percentWidthFromFixedWidth model =
    let
        percentWidth =
            let
                fixedWidth_ =
                    toFloat model.fixedWidth

                initialWidth =
                    toFloat model.initialSize.width
            in
            (fixedWidth_ / initialWidth) * 100
    in
    { model
        | percentWidthField = toString percentWidth
        , percentWidth = percentWidth
    }


heightFromFixedWidth : Model -> Model
heightFromFixedWidth model =
    if model.lockRatio then
        let
            fixedHeight =
                [ toFloat model.initialSize.height
                , toFloat model.fixedWidth
                , 1 / toFloat model.initialSize.width
                ]
                    |> List.product
                    |> Basics.round
        in
        { model
            | fixedHeight = fixedHeight
            , fixedHeightField = toString fixedHeight
            , percentHeight =
                let
                    initialHeight =
                        toFloat model.initialSize.height
                in
                (toFloat fixedHeight / initialHeight) * 100
        }
    else
        model


parseFixedHeight : Model -> Model
parseFixedHeight model =
    case String.toInt model.fixedHeightField of
        Ok fixedHeight ->
            { model | fixedHeight = fixedHeight }
                |> percentHeightFromFixedHeight
                |> widthFromFixedHeight

        Err err ->
            model


percentHeightFromFixedHeight : Model -> Model
percentHeightFromFixedHeight model =
    let
        percentHeight =
            let
                fixedHeight_ =
                    toFloat model.fixedHeight

                initialHeight =
                    toFloat model.initialSize.height
            in
            (fixedHeight_ / initialHeight) * 100
    in
    { model
        | percentHeightField = toString (Basics.round percentHeight)
        , percentHeight = percentHeight
    }


widthFromFixedHeight : Model -> Model
widthFromFixedHeight model =
    if model.lockRatio then
        let
            fixedWidth =
                [ toFloat model.initialSize.width
                , toFloat model.fixedHeight
                , 1 / toFloat model.initialSize.height
                ]
                    |> List.product
                    |> Basics.round
        in
        { model
            | fixedWidth = fixedWidth
            , fixedWidthField = toString fixedWidth
            , percentWidth =
                let
                    initialWidth =
                        toFloat model.initialSize.width
                in
                (toFloat fixedWidth / initialWidth) * 100
        }
    else
        model


parsePercentWidth : Model -> Model
parsePercentWidth model =
    case String.toFloat model.percentWidthField of
        Ok percentWidth ->
            { model | percentWidth = percentWidth }
                |> fixedWidthFromPercentWidth
                |> heightFromPercentWidth

        Err err ->
            model


fixedWidthFromPercentWidth : Model -> Model
fixedWidthFromPercentWidth model =
    let
        fixedWidth =
            let
                initialWidth =
                    toFloat model.initialSize.width
            in
            Basics.round (initialWidth * (model.percentWidth / 100))
    in
    { model
        | fixedWidth = fixedWidth
        , fixedWidthField = toString fixedWidth
    }


heightFromPercentWidth : Model -> Model
heightFromPercentWidth model =
    if model.lockRatio then
        { model
            | percentHeight = model.percentWidth
            , percentHeightField = model.percentWidthField
            , fixedHeight =
                let
                    initialHeight =
                        toFloat model.initialSize.height
                in
                Basics.round (initialHeight * (model.percentWidth / 100))
        }
    else
        model


parsePercentHeight : Model -> Model
parsePercentHeight model =
    case String.toFloat model.percentHeightField of
        Ok percentHeight ->
            { model | percentHeight = percentHeight }
                |> fixedHeightFromPercentHeight
                |> widthFromPercentHeight

        Err err ->
            model


fixedHeightFromPercentHeight : Model -> Model
fixedHeightFromPercentHeight model =
    let
        fixedHeight =
            let
                initialHeight =
                    toFloat model.initialSize.height
            in
            Basics.round (initialHeight * (model.percentHeight / 100))
    in
    { model
        | fixedHeight = fixedHeight
        , fixedHeightField = toString fixedHeight
    }


widthFromPercentHeight : Model -> Model
widthFromPercentHeight model =
    if model.lockRatio then
        { model
            | percentWidth = model.percentHeight
            , percentWidthField = model.percentHeightField
            , fixedWidth =
                let
                    initialWidth =
                        toFloat model.initialSize.width
                in
                Basics.round (initialWidth * (model.percentWidth / 100))
        }
    else
        model
