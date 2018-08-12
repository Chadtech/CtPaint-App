module Canvas.Draw exposing (..)

import Array exposing (Array)
import Canvas
    exposing
        ( Canvas
        , DrawImageParams(..)
        , DrawOp(..)
        , Point
        , Size
        )
import Color exposing (Color)
import Color.Util
import Data.Size as Size
import Hfnss exposing (Pixel(..))
import List.Extra as LE
import Position.Data as Position exposing (Position)
import RasterShapes as Shapes
import Util exposing (withIndex)


-- RESIZE --


resize : Position -> Size -> Color -> Canvas -> Canvas
resize position size fillerColor canvas =
    size
        |> Canvas.initialize
        |> Canvas.draw (filledRectangle fillerColor size { x = 0, y = 0 })
        |> Canvas.draw (pasteSelection position canvas)



-- REPLACE --


replace : Color -> Color -> Canvas -> Canvas
replace target replacement canvas =
    Canvas.replace target replacement canvas



-- TEXT --


text : String -> Color -> Canvas
text str color =
    let
        lines =
            str
                |> String.split "\n"
                |> List.map String.toList
    in
    { width =
        List.map List.length lines
            |> List.maximum
            |> Maybe.withDefault 0
            |> (*) 11
    , height =
        List.length lines * 19
    }
        |> Canvas.initialize
        |> Canvas.draw (textOp lines color)


textOp : List (List Char) -> Color -> DrawOp
textOp chars color =
    chars
        |> toMatrix
        |> toCharPoints
        |> charsToLetters
        |> List.map (Tuple.mapSecond toLetterPoints)
        |> mergePoints
        |> List.map (toDrawOps color)
        |> Canvas.batch


toDrawOps : Color -> ( Point, Pixel ) -> DrawOp
toDrawOps color ( point, fontPixel ) =
    case fontPixel of
        Gray ->
            pixel color point

        Black ->
            Canvas.batch []


mergePoints : List ( Point, List ( Point, Pixel ) ) -> List ( Point, Pixel )
mergePoints =
    List.map (Tuple.mapFirst toLetterSize)
        >> List.map mergeThisPoint
        >> List.concat


mergeThisPoint : ( Point, List ( Point, Pixel ) ) -> List ( Point, Pixel )
mergeThisPoint ( point, pixels ) =
    pixels
        |> List.map (Tuple.mapFirst (combinePoints point))


combinePoints : Point -> Point -> Point
combinePoints p0 p1 =
    { x = p0.x + p1.x
    , y = p0.y + p1.y
    }


toLetterSize : Point -> Point
toLetterSize { x, y } =
    { x = x * 11, y = y * 19 }


toLetterPoints : List (List Pixel) -> List ( Point, Pixel )
toLetterPoints =
    List.map withIndex
        >> withIndex
        >> List.map withY
        >> List.concat


charsToLetters : List ( Point, Char ) -> List ( Point, List (List Pixel) )
charsToLetters =
    List.map (Tuple.mapSecond Hfnss.get)


toMatrix : List (List a) -> List ( Int, List ( Int, a ) )
toMatrix =
    List.map withIndex >> withIndex


toCharPoints : List ( Int, List ( Int, Char ) ) -> List ( Point, Char )
toCharPoints =
    List.map withY >> List.concat


withY : ( Int, List ( Int, item ) ) -> List ( Point, item )
withY ( y, row ) =
    List.map (withX y) row


withX : Int -> ( Int, item ) -> ( Point, item )
withX y ( x, item ) =
    ( { x = toFloat x, y = toFloat y }, item )



-- INVERT --


invert : Canvas -> Canvas
invert canvas =
    let
        drawOp =
            [ GlobalCompositionOp "difference"
            , FillStyle Color.white
            , FillRect
                { x = 0, y = 0 }
                (Canvas.getSize canvas)
            ]
                |> Canvas.batch
    in
    Canvas.draw drawOp canvas



-- ROTATE AND FLIP --


flipVertical : Canvas -> Canvas
flipVertical canvas =
    let
        { width, height } =
            Canvas.getSize canvas

        newCanvas =
            Canvas.initialize
                { width = width
                , height = height
                }

        drawOp =
            Canvas.batch
                [ Scale 1 -1
                , DrawImage
                    canvas
                    (At (Point 0 (toFloat -height)))
                ]
    in
    Canvas.draw drawOp newCanvas


flipHorizontal : Canvas -> Canvas
flipHorizontal canvas =
    let
        { width, height } =
            Canvas.getSize canvas

        newCanvas =
            Canvas.initialize
                { width = width
                , height = height
                }

        drawOp =
            Canvas.batch
                [ Scale -1 1
                , DrawImage
                    canvas
                    (At (Point (toFloat -width) 0))
                ]
    in
    Canvas.draw drawOp newCanvas


rotate270 : Canvas -> Canvas
rotate270 canvas =
    let
        { width, height } =
            Canvas.getSize canvas

        newCanvas =
            Canvas.initialize
                { width = height
                , height = width
                }

        drawOp =
            Canvas.batch
                [ Rotate ((3 * pi) / 2)
                , DrawImage
                    canvas
                    (At (Point (toFloat -width) 0))
                ]
    in
    Canvas.draw drawOp newCanvas


rotate90 : Canvas -> Canvas
rotate90 canvas =
    let
        { width, height } =
            Canvas.getSize canvas

        newCanvas =
            Canvas.initialize
                { width = height
                , height = width
                }

        drawOp =
            Canvas.batch
                [ Rotate (pi / 2)
                , DrawImage
                    canvas
                    (At (Point 0 (toFloat -height)))
                ]
    in
    Canvas.draw drawOp newCanvas


rotate180 : Canvas -> Canvas
rotate180 canvas =
    let
        { width, height } =
            Canvas.getSize canvas

        newCanvas =
            Canvas.initialize
                { width = width
                , height = height
                }

        drawOp =
            let
                at =
                    Point
                        (toFloat -width)
                        (toFloat -height)
                        |> At
            in
            Canvas.batch
                [ Scale -1 -1
                , DrawImage canvas at
                ]
    in
    Canvas.draw drawOp newCanvas


ellipse : Color -> Position -> Position -> DrawOp
ellipse color p0 p1 =
    Canvas.ellipse (Position.toPoint p0) (Position.toPoint p1)
        |> List.map (pixel color)
        |> Canvas.batch



-- LINE --


line : Color -> Position -> Position -> DrawOp
line color p0 p1 =
    Shapes.line p0 p1
        |> List.map (Position.toPoint >> pixel color)
        |> Canvas.batch



-- PIXEL --


pixel : Color -> Point -> DrawOp
pixel color point =
    PutImageData
        (fromColor color)
        (Size 1 1)
        point


fromColor : Color -> List Int
fromColor color =
    let
        { red, green, blue, alpha } =
            Color.toRgb color
    in
    [ red
    , green
    , blue
    , round (alpha * 255)
    ]



-- RECTANGLE --


rectangle : Color -> Position -> Position -> DrawOp
rectangle color p q =
    Shapes.rectangle2 p q
        |> List.map (Position.toPoint >> pixel color)
        |> Canvas.batch


filledRectangle : Color -> Size -> Position -> DrawOp
filledRectangle color size position =
    [ BeginPath
    , Rect (Position.toPoint position) size
    , FillStyle color
    , Fill
    ]
        |> Canvas.batch


eraser : Color -> Int -> Position -> Position -> DrawOp
eraser color size p0 p1 =
    Shapes.line p0 p1
        |> List.map (eraserPoint color size)
        |> Canvas.batch


eraserPoint : Color -> Int -> Position -> DrawOp
eraserPoint color size position =
    filledRectangle
        color
        { width = size
        , height = size
        }
        { x = position.x - (size // 2)
        , y = position.y - (size // 2)
        }



-- SELECT --


pasteSelection : Position -> Canvas -> DrawOp
pasteSelection position selection =
    DrawImage selection (At (Position.toPoint position))


getSelection : Position -> Position -> Color -> Canvas -> ( Canvas, DrawOp )
getSelection p q color canvas =
    let
        origin : Position
        origin =
            Position.min p q

        size : Size
        size =
            Size.fromPositions p q

        cropOp : DrawOp
        cropOp =
            CropScaled
                (Position.toPoint origin)
                size
                (Point 0 0)
                size
                |> DrawImage canvas
    in
    ( Canvas.draw
        cropOp
        (Canvas.initialize size)
    , filledRectangle color size origin
    )


crop : Position -> Position -> Canvas -> Canvas
crop p q canvas =
    let
        origin : Position
        origin =
            Position.min p q

        size : Size
        size =
            Size.fromPositions p q

        cropOp : DrawOp
        cropOp =
            CropScaled
                (Position.toPoint origin)
                size
                (Point 0 0)
                size
                |> DrawImage canvas
    in
    Canvas.draw
        cropOp
        (Canvas.initialize size)



-- UTIL --


makeRectParams : Position -> Position -> ( Position, Size )
makeRectParams p q =
    ( Position.min p q
    , Size (abs (p.x - q.x)) (abs (p.y - q.y))
    )


colorAt : Position -> Canvas -> Color
colorAt pos =
    Canvas.getImageData (Position.toPoint pos) (Size 1 1)
        >> Color.Util.fromInts
