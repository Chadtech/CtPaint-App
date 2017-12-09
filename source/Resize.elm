module Resize
    exposing
        ( Model
        , Msg(..)
        , css
        , init
        , update
        , view
        )

import Css exposing (..)
import Css.Elements
import Css.Namespace exposing (namespace)
import Html
    exposing
        ( Html
        )
import Html.CssHelpers
import Html.Custom
import Reply exposing (Reply(NoReply, ResizeTo))
import Tuple.Infix exposing ((&), (|&))
import Window exposing (Size)


-- TYPES --


type alias Model =
    { leftField : String
    , rightField : String
    , topField : String
    , bottomField : String
    , widthField : String
    , heightField : String
    , left : Int
    , right : Int
    , top : Int
    , bottom : Int
    , width : Int
    , height : Int
    , sourceWidth : Int
    , sourceHeight : Int
    }


type Msg
    = FieldUpdated Field String
    | ResizeClicked


type Field
    = Left
    | Right
    | Top
    | Bottom
    | Width
    | Height



-- INIT --


init : Size -> Model
init size =
    { leftField = "0"
    , rightField = "0"
    , topField = "0"
    , bottomField = "0"
    , widthField = toString size.width
    , heightField = toString size.height
    , left = 0
    , right = 0
    , top = 0
    , bottom = 0
    , width = size.width
    , height = size.height
    , sourceWidth = size.width
    , sourceHeight = size.height
    }



-- STYLES --


type Class
    = Field


css : Stylesheet
css =
    []
        |> namespace resizeNamespace
        |> stylesheet


resizeNamespace : String
resizeNamespace =
    Html.Custom.makeNamespace "Resize"



-- VIEW --


{ class } =
    Html.CssHelpers.withNamespace resizeNamespace


view : Model -> List (Html Msg)
view model =
    []



-- UPDATE --


update : Msg -> Model -> ( Model, Reply )
update msg model =
    case msg of
        FieldUpdated Left str ->
            { model | leftField = str }
                |> cohere Left str
                & NoReply

        FieldUpdated Right str ->
            { model | rightField = str }
                & NoReply

        FieldUpdated Top str ->
            { model | topField = str }
                & NoReply

        FieldUpdated Bottom str ->
            { model | bottomField = str }
                & NoReply

        FieldUpdated Width str ->
            { model | widthField = str }
                & NoReply

        FieldUpdated Height str ->
            { model | heightField = str }
                & NoReply

        ResizeClicked ->
            ResizeTo model.left model.top model.width model.height
                |& model


cohere : Field -> String -> Model -> Model
cohere field str model =
    case String.toInt str of
        Ok int ->
            case field of
                Left ->
                    { model | left = int }
                        |> cohereDimensions

                Right ->
                    { model | right = int }
                        |> cohereDimensions

                Top ->
                    { model | top = int }
                        |> cohereDimensions

                Bottom ->
                    { model | bottom = int }
                        |> cohereDimensions

                Width ->
                    { model | width = int }
                        |> coherePadding

                Height ->
                    { model | height = int }
                        |> coherePadding

        Err _ ->
            model


cohereDimensions : Model -> Model
cohereDimensions model =
    { model
        | width = model.sourceWidth + model.left + model.right
        , height = model.sourceHeight + model.top + model.bottom
    }


coherePadding : Model -> Model
coherePadding model =
    let
        dw =
            model.width - model.sourceWidth

        dh =
            model.height - model.sourceHeight
    in
    { model
        | left = model.left + (dw // 2)
        , right = model.right + (dw // 2) + (dw % 2)
        , top = model.top + (dh // 2)
        , bottom = model.bottom + (dh // 2) + (dh % 2)
    }
