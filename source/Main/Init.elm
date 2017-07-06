module Main.Init exposing (..)

import Main.Model exposing (Model)
import Main.Message exposing (Message(..))
import Json.Decode exposing (Value)
import Canvas exposing (Canvas, Size, DrawOp(..), Point)
import Types.Session as Session
import Tool.Types exposing (Tool(..))
import Json.Decode as Decode exposing (Decoder)
import Mouse exposing (Position)
import Color
import Palette.Init


init : Value -> ( Model, Cmd Message )
init json =
    let
        windowSize =
            decodeWindow json

        canvas =
            Canvas.initialize (Size 400 400)
                |> fillBlack
    in
        { session = Session.decode json
        , canvas = canvas
        , canvasPosition =
            getCanvasPosition
                windowSize
                (Canvas.getSize canvas)
        , pendingDraw = Canvas.batch []
        , swatches = Palette.Init.swatches
        , palette = Palette.Init.palette
        , horizontalToolbarHeight = 58
        , subMouseMove = Nothing
        , windowSize = windowSize
        , tool = Hand Nothing
        }
            ! []



-- INIT CANVAS --


getCanvasPosition : Size -> Size -> Position
getCanvasPosition window { width, height } =
    Position
        ((window.width - width) // 2)
        ((window.height - height) // 2)


fillBlack : Canvas -> Canvas
fillBlack canvas =
    Canvas.draw (fillBlackOp canvas) canvas


fillBlackOp : Canvas -> DrawOp
fillBlackOp canvas =
    [ BeginPath
    , Rect (Point 0 0) (Canvas.getSize canvas)
    , FillStyle Color.black
    , Fill
    ]
        |> Canvas.batch



-- WINDOW SIZE DECODER --


decodeWindow : Value -> Size
decodeWindow json =
    case Decode.decodeValue windowDecoder json of
        Ok ( w, h ) ->
            Size w h

        Err _ ->
            Size 800 800


windowDecoder : Decoder ( Int, Int )
windowDecoder =
    Decode.map2 (,)
        (Decode.field "windowWidth" Decode.int)
        (Decode.field "windowHeight" Decode.int)
