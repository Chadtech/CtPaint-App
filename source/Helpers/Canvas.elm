module Helpers.Canvas
    exposing
        ( Params
        , blank
        , fromParams
        , noop
        , tiny
        )

import Canvas exposing (Canvas, DrawOp(..), Size)
import Color exposing (Color)
import Data.Color exposing (BackgroundColor(Black, White))


type alias Params =
    { name : Maybe String
    , width : Maybe Int
    , height : Maybe Int
    , backgroundColor : Maybe BackgroundColor
    }


fromParams : Params -> Canvas
fromParams params =
    let
        fromSize : Size -> Canvas
        fromSize =
            Canvas.initialize
                >> fill (getColor params.backgroundColor)
    in
    case ( params.width, params.height ) of
        ( Just width, Just height ) ->
            { width = width
            , height = height
            }
                |> fromSize

        ( Just width, Nothing ) ->
            { width = width
            , height = width
            }
                |> fromSize

        ( Nothing, Just height ) ->
            { width = height
            , height = height
            }
                |> fromSize

        ( Nothing, Nothing ) ->
            fromSize defaultSize


getColor : Maybe BackgroundColor -> BackgroundColor
getColor =
    Maybe.withDefault Black


blank : Canvas
blank =
    defaultSize
        |> Canvas.initialize
        |> fill Black


defaultSize : Size
defaultSize =
    { width = 400
    , height = 400
    }


{-| I use this super small canvas to make it easy to hide,
which I do when the app is initialized, but the user hasnt
set any parameters on their project (width, heigt, background
color)
-}
tiny : Canvas
tiny =
    { width = 1, height = 1 }
        |> Canvas.initialize
        |> fill Black


noop : DrawOp
noop =
    Canvas.batch []


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
