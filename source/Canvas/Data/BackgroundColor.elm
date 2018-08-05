module Canvas.Data.BackgroundColor
    exposing
        ( BackgroundColor(..)
        , decoder
        , fill
        , toColor
        , toString
        )

import Canvas exposing (Canvas, DrawOp(..))
import Color exposing (Color)
import Json.Decode as JD exposing (Decoder)


-- TYPES --


type BackgroundColor
    = Black
    | White



-- DECODER --


decoder : Decoder BackgroundColor
decoder =
    JD.string
        |> JD.andThen toBackgroundColor


toBackgroundColor : String -> Decoder BackgroundColor
toBackgroundColor str =
    case str of
        "black" ->
            JD.succeed Black

        "white" ->
            JD.succeed White

        _ ->
            JD.fail ("Background color isnt black or white, its " ++ str)



-- HELPERS --


toString : BackgroundColor -> String
toString =
    Basics.toString >> String.toLower


fill : BackgroundColor -> Canvas -> Canvas
fill backgroundColor canvas =
    Canvas.draw
        (fillOp backgroundColor canvas)
        canvas


toColor : BackgroundColor -> Color
toColor backgroundColor =
    case backgroundColor of
        Black ->
            Color.black

        White ->
            Color.white


fillOp : BackgroundColor -> Canvas -> DrawOp
fillOp backgroundColor canvas =
    [ BeginPath
    , Rect { x = 0, y = 0 } (Canvas.getSize canvas)
    , FillStyle (toColor backgroundColor)
    , Canvas.Fill
    ]
        |> Canvas.batch
