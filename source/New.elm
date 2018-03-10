module New exposing (..)

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Color exposing (BackgroundColor(Black, White))
import Helpers.Canvas as Canvas exposing (Params)
import Html exposing (Attribute, Html, a, div, form, input, p)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Reply exposing (Reply(NoReply, StartNewDrawing))
import Tuple.Infix exposing ((&), (:=))


-- TYPES --


type Msg
    = ColorClicked BackgroundColor
    | FieldUpdated Field String
    | StartClicked
    | StartSubmitted


type Field
    = Width
    | Height
    | Name


type alias Model =
    { initName : String
    , nameField : String
    , width : Int
    , widthField : String
    , height : Int
    , heightField : String
    , backgroundColor : BackgroundColor
    }



-- INIT --


init : String -> Model
init name =
    { initName = name
    , nameField = ""
    , width = 400
    , widthField = ""
    , height = 400
    , heightField = ""
    , backgroundColor = Black
    }



-- UPDATE --


update : Msg -> Model -> ( Model, Reply )
update msg model =
    case msg of
        FieldUpdated Width str ->
            { model | widthField = str }
                |> validateWidth
                & NoReply

        FieldUpdated Height str ->
            { model | heightField = str }
                |> validateHeight
                & NoReply

        FieldUpdated Name str ->
            { model
                | nameField = str
            }
                & NoReply

        ColorClicked color ->
            { model | backgroundColor = color }
                & NoReply

        StartClicked ->
            model & startReply model

        StartSubmitted ->
            model & startReply model


startReply : Model -> Reply
startReply model =
    model
        |> toParams
        |> Canvas.fromParams
        |> StartNewDrawing (determineName model) (model.nameField /= "")


toParams : Model -> Canvas.Params
toParams model =
    { name = Just (determineName model)
    , width = Just model.width
    , height = Just model.height
    , backgroundColor = Just model.backgroundColor
    }


determineName : Model -> String
determineName model =
    case model.nameField of
        "" ->
            model.initName

        _ ->
            model.nameField


validateWidth : Model -> Model
validateWidth model =
    case String.toInt model.widthField of
        Ok int ->
            { model | width = int }

        Err _ ->
            model


validateHeight : Model -> Model
validateHeight model =
    case String.toInt model.heightField of
        Ok int ->
            { model | height = int }

        Err _ ->
            model



-- STYLES --


type Class
    = Label
    | Field
    | Button
    | Selected
    | WhiteClass
    | BlackClass
    | ColorBox
    | ColorsContainer
    | Disabled
    | Left
    | InitializingText


css : Stylesheet
css =
    [ Css.class Label
        [ marginRight (px 8)
        , width (px 200)
            |> important
        ]
    , Css.class Field
        [ displayFlex ]
    , Css.class Button
        [ margin2 zero auto
        , display table
        , withClass Disabled
            [ backgroundColor Ct.ignorable1
            , active Html.Custom.outdent
            , hover
                [ color Ct.point0 ]
            ]
        ]
    , (Css.class ColorBox << List.append Html.Custom.outdent)
        [ height (px 19)
        , paddingTop (px 1)
        , width (px 107)
        , marginRight (px 8)
        , display inlineBlock
        , cursor pointer
        , withClass BlackClass
            [ backgroundColor (hex "#000000") ]
        , withClass WhiteClass
            [ backgroundColor (hex "#ffffff") ]
        , withClass Selected
            Html.Custom.indent
        , active Html.Custom.indent
        ]
    , Css.class Left
        [ marginRight (px 8) ]
    , Css.class InitializingText
        [ marginBottom (px 8) ]
    , Css.class ColorsContainer
        [ display inlineFlex ]
    ]
        |> namespace newNamespace
        |> stylesheet


colorToStyle : BackgroundColor -> Class
colorToStyle backgroundColor =
    case backgroundColor of
        White ->
            WhiteClass

        Black ->
            BlackClass


newNamespace : String
newNamespace =
    Html.Custom.makeNamespace "NewDrawingModule"



-- VIEW --


{ class, classList } =
    Html.CssHelpers.withNamespace newNamespace


view : Model -> List (Html Msg)
view model =
    [ Html.Custom.field
        [ class [ Field ] ]
        [ label "name"
        , input
            [ Attrs.value model.nameField
            , Attrs.placeholder model.initName
            , Attrs.spellcheck False
            , onInput (FieldUpdated Name)
            ]
            []
        ]
    , Html.Custom.field
        [ class [ Field ] ]
        [ label "width"
        , input
            [ Attrs.value model.widthField
            , Attrs.placeholder
                (toString model.width ++ "px")
            , Attrs.spellcheck False
            , onInput (FieldUpdated Width)
            ]
            []
        ]
    , Html.Custom.field
        [ class [ Field ] ]
        [ label "height"
        , input
            [ Attrs.value model.heightField
            , Attrs.placeholder
                (toString model.height ++ "px")
            , Attrs.spellcheck False
            , onInput (FieldUpdated Height)
            ]
            []
        ]
    , Html.Custom.field
        [ class [ Field ] ]
        [ label "background color"
        , div
            [ class [ ColorsContainer ] ]
            [ colorBox Black model.backgroundColor
            , colorBox White model.backgroundColor
            ]
        ]
    , a
        (startNewButtonAttrs model)
        [ Html.text "start" ]
    ]
        |> form [ onSubmit StartSubmitted ]
        |> List.singleton


startNewButtonAttrs : Model -> List (Attribute Msg)
startNewButtonAttrs model =
    [ class [ Button ]
    , onClick StartClicked
    ]


colorBox : BackgroundColor -> BackgroundColor -> Html Msg
colorBox thisColor selectedColor =
    div
        [ classList
            [ ColorBox := True
            , colorToStyle thisColor := True
            , Selected := (selectedColor == thisColor)
            , Left := thisColor == Black
            ]
        , onClick (ColorClicked thisColor)
        ]
        []


label : String -> Html Msg
label str =
    p
        [ class [ Label ] ]
        [ Html.text str ]
