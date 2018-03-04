module New exposing (..)

import Canvas exposing (Canvas, Size)
import Color
import Data.Color exposing (BackgroundColor(Black, White))
import Draw
import Html exposing (Html, div)
import Tuple.Infix exposing ((&))


type Msg
    = ColorSelect BackgroundColor
    | UpdateField Field String
    | AttemptInit


type Field
    = Width
    | Height


type ExternalMsg
    = DoNothing
    | InitCanvas Canvas


type alias Model =
    { widthField : String
    , heightField : String
    , width : Maybe Int
    , height : Maybe Int
    , backgroundColor : BackgroundColor
    }



-- UPDATE --


update : Msg -> Model -> ( Model, ExternalMsg )
update msg model =
    case msg of
        UpdateField Width str ->
            { model
                | widthField = str
                , width =
                    Result.toMaybe (String.toInt str)
            }
                & DoNothing

        UpdateField Height str ->
            { model
                | heightField = str
                , height =
                    Result.toMaybe (String.toInt str)
            }
                & DoNothing

        ColorSelect color ->
            { model
                | backgroundColor = color
            }
                & DoNothing

        AttemptInit ->
            case ( model.width, model.height ) of
                ( Just width, Just height ) ->
                    let
                        size =
                            { width = width
                            , height = height
                            }
                    in
                    model & initCanvas size model.backgroundColor

                _ ->
                    model & DoNothing


initCanvas : Size -> BackgroundColor -> ExternalMsg
initCanvas size backgroundColor =
    let
        color =
            case backgroundColor of
                Black ->
                    Color.black

                White ->
                    Color.white

        canvas =
            Canvas.initialize size

        drawOp =
            Draw.filledRectangle
                color
                size
                { x = 0, y = 0 }
    in
    Canvas.initialize size
        |> Canvas.draw drawOp
        |> InitCanvas



-- VIEW --


view : Model -> List (Html Msg)
view model =
    [ div
        []
        []
    ]



-- INIT --


init : Model
init =
    { widthField = "400"
    , heightField = "400"
    , width = Just 400
    , height = Just 400
    , backgroundColor = Black
    }
