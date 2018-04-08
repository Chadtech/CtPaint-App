module New exposing (..)

import Chadtech.Colors as Ct
import Css exposing (..)
import Css.Namespace exposing (namespace)
import Data.Color exposing (BackgroundColor(Black, White))
import Data.Taco exposing (Taco)
import Helpers.Canvas as Canvas
    exposing
        ( Params
        , backgroundColorStr
        )
import Html exposing (Attribute, Html, a, div, form, input, p)
import Html.Attributes as Attrs
import Html.CssHelpers
import Html.Custom
import Html.Events exposing (onClick, onInput, onSubmit)
import Ports
import Reply exposing (Reply(StartNewDrawing))
import Return2 as R2
import Return3 as R3 exposing (Return)
import Tracking
    exposing
        ( Event
            ( MenuNewColorClick
            , MenuNewStartClick
            , MenuNewStartEnterPress
            )
        )
import Util exposing (def)
import Window exposing (Size)


-- TYPES --


type Msg
    = ColorClicked BackgroundColor
    | FieldUpdated Field String
    | StartClicked
    | StartSubmitted
    | EnterPressed


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


toSize : Model -> Size
toSize model =
    { width = model.width
    , height = model.height
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


update : Taco -> Msg -> Model -> Return Model Msg Reply
update taco msg model =
    case msg of
        FieldUpdated Width str ->
            { model | widthField = str }
                |> validateWidth
                |> R3.withNothing

        FieldUpdated Height str ->
            { model | heightField = str }
                |> validateHeight
                |> R3.withNothing

        FieldUpdated Name str ->
            { model
                | nameField = str
            }
                |> R3.withNothing

        ColorClicked color ->
            { model | backgroundColor = color }
                |> R2.withCmd (trackColorClick taco color)
                |> R3.withNoReply

        StartClicked ->
            trackStartClick taco model
                |> R2.withModel model
                |> R3.withReply (startReply model)

        StartSubmitted ->
            trackStartEnterPress taco model
                |> R2.withModel model
                |> R3.withReply (startReply model)

        EnterPressed ->
            trackStartEnterPress taco model
                |> R2.withModel model
                |> R3.withReply (startReply model)


trackStartClick : Taco -> Model -> Cmd Msg
trackStartClick taco model =
    model.backgroundColor
        |> backgroundColorStr
        |> MenuNewStartClick (toSize model)
        |> Ports.track taco


trackStartEnterPress : Taco -> Model -> Cmd Msg
trackStartEnterPress taco model =
    model.backgroundColor
        |> backgroundColorStr
        |> MenuNewStartEnterPress (toSize model)
        |> Ports.track taco


trackColorClick : Taco -> BackgroundColor -> Cmd Msg
trackColorClick taco bgColor =
    bgColor
        |> backgroundColorStr
        |> MenuNewColorClick
        |> Ports.track taco


startReply : Model -> Reply
startReply model =
    model
        |> toParams
        |> Canvas.fromParams
        |> StartNewDrawing
            (determineName model)
            (model.nameField /= "")


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


view : Model -> Html Msg
view model =
    [ Html.Custom.field
        [ class [ Field ]
        , onSubmit StartSubmitted
        ]
        [ label "name"
        , input
            [ Attrs.value model.nameField
            , Attrs.placeholder model.initName
            , Attrs.spellcheck False
            , onInput (FieldUpdated Name)
            , Util.onEnter EnterPressed
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
    , input
        [ Attrs.type_ "submit"
        , Attrs.hidden True
        ]
        []
    , a
        (startNewButtonAttrs model)
        [ Html.text "start" ]
    ]
        |> Html.Custom.cardBody []


startNewButtonAttrs : Model -> List (Attribute Msg)
startNewButtonAttrs model =
    [ class [ Button ]
    , onClick StartClicked
    ]


colorBox : BackgroundColor -> BackgroundColor -> Html Msg
colorBox thisColor selectedColor =
    div
        [ classList
            [ def ColorBox True
            , def (colorToStyle thisColor) True
            , def Selected (selectedColor == thisColor)
            , def Left (thisColor == Black)
            ]
        , onClick (ColorClicked thisColor)
        ]
        []


label : String -> Html Msg
label str =
    p
        [ class [ Label ] ]
        [ Html.text str ]
