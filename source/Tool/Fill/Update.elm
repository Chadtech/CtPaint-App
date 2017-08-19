module Tool.Fill.Update exposing (update)

import Main.Model exposing (Model)
import Tool.Fill.Types exposing (Message(..))
import Tool.Util exposing (adjustPosition)
import Util exposing (tbw, toPoint, maybeCons)
import Draw.Util
import Draw.Pixel as Pixel
import Canvas exposing (Size, Point, Canvas, DrawOp(..))
import List.Extra
import Array exposing (Array)
import Color exposing (Color)
import Mouse exposing (Position)
import Debug exposing (log)


update : Message -> Model -> Model
update message model =
    case message of
        SubMouseUp position ->
            let
                positonOnCanvas =
                    adjustPosition model tbw position

                colorAtPosition =
                    Draw.Util.colorAt
                        positonOnCanvas
                        model.canvas
            in
                if colorAtPosition /= model.swatches.primary then
                    { model
                        | pendingDraw =
                            Canvas.batch
                                [ model.pendingDraw
                                , PixelFill
                                    model.swatches.primary
                                    (toPoint positonOnCanvas)
                                ]
                    }
                else
                    model


toArray : Canvas -> Array Color
toArray canvas =
    canvas
        |> Canvas.getImageData
            (Point 0 0)
            (Canvas.getSize canvas)
        |> Util.groupsOfFour
        |> List.map Draw.Util.toColor
        |> Array.fromList


fill : Color -> Color -> Position -> Canvas -> DrawOp
fill targetColor changeColor position canvas =
    let
        size =
            Canvas.getSize canvas
    in
        fillInit
            targetColor
            changeColor
            position
            size
            canvas
            |> List.map
                (indicesToPoint size.width >> Pixel.draw changeColor)
            |> Canvas.batch


fillInit : Color -> Color -> Position -> Size -> Canvas -> List Int
fillInit targetColor changeColor { x, y } size canvas =
    let
        ( _, indices, _ ) =
            fillRecursive
                targetColor
                changeColor
                size
                ( toArray canvas
                , [ x + (size.width * y) ]
                , [ x + (size.width * y) ]
                )
    in
        indices


indicesToPoint : Int -> Int -> Point
indicesToPoint width index =
    { x = toFloat (index % width)
    , y = toFloat (index // width)
    }


fillRecursive : Color -> Color -> Size -> ( Array Color, List Int, List Int ) -> ( Array Color, List Int, List Int )
fillRecursive targetColor changeColor size ( canvasData, totalIndices, indices ) =
    let
        nextIndices =
            indices
                |> List.map
                    (getNeighbors canvasData targetColor size)
                |> List.concat
                |> List.Extra.unique
                |> List.filter (Util.contains totalIndices >> not)
    in
        if nextIndices == indices then
            ( Array.empty
            , totalIndices
            , []
            )
        else
            let
                nextCanvasData =
                    List.foldr
                        (setColorAt changeColor)
                        canvasData
                        indices
            in
                fillRecursive
                    targetColor
                    changeColor
                    size
                    ( nextCanvasData
                    , nextIndices ++ totalIndices
                    , nextIndices
                    )


setColorAt : Color -> Int -> Array Color -> Array Color
setColorAt changeColor index canvasData =
    Array.set index changeColor canvasData


getNeighbors : Array Color -> Color -> Size -> Int -> List Int
getNeighbors canvasData targetColor { width, height } index =
    let
        left : List Int -> List Int
        left list =
            let
                isntTooFarLeft =
                    (index % width) /= 0

                isColor =
                    Just targetColor == Array.get (index - 1) canvasData
            in
                if isntTooFarLeft && isColor then
                    (index - 1) :: list
                else
                    list

        right : List Int -> List Int
        right list =
            let
                isntTooFarRight =
                    (index % width) /= (width - 1)

                isColor =
                    Just targetColor == Array.get (index + 1) canvasData
            in
                if isntTooFarRight && isColor then
                    (index + 1) :: list
                else
                    list

        top : List Int -> List Int
        top list =
            case Array.get (index - width) canvasData of
                Just color ->
                    if color == targetColor then
                        (index - width) :: list
                    else
                        list

                Nothing ->
                    list

        bottom : List Int -> List Int
        bottom list =
            case Array.get (index + width) canvasData of
                Just color ->
                    if color == targetColor then
                        (index + width) :: list
                    else
                        list

                Nothing ->
                    list
    in
        []
            |> left
            |> right
            |> top
            |> bottom
