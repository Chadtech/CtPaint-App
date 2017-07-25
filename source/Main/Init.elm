module Main.Init exposing (..)

import Main.Model exposing (Model)
import Main.Message exposing (Message(..))
import Json.Decode exposing (Value)
import Canvas exposing (Canvas, Size, DrawOp(..), Point)
import Types.Session as Session
import Tool.Types exposing (Tool(..))
import ColorPicker.Types as ColorPicker
import Json.Decode as Decode exposing (Decoder)
import Mouse exposing (Position)
import Color
import Palette.Init
import Util exposing (tbw)
import History.Types exposing (HistoryOp(..))


init : Value -> ( Model, Cmd Message )
init json =
    let
        windowSize =
            decodeWindow json

        canvas =
            Canvas.initialize (Size 400 400)
                |> fillBlack

        canvasSize =
            Canvas.getSize canvas
    in
        { session = Session.decode json
        , canvas = canvas
        , canvasPosition =
            Position
                (((windowSize.width - tbw) - canvasSize.width) // 2)
                ((windowSize.height - canvasSize.height) // 2)
        , pendingDraw = Canvas.batch []
        , drawAtRender = Canvas.batch []
        , swatches = Palette.Init.swatches
        , palette = Palette.Init.palette
        , horizontalToolbarHeight = 58
        , subMouseMove = Nothing
        , windowSize = windowSize
        , tool = Hand Nothing
        , zoom = 1
        , colorPicker = ColorPicker.init Palette.Init.palette
        , ctrlDown = False
        , textInputFocused = False
        , history = [ CanvasChange canvas ]
        , future = []
        }
            ! []



-- INIT CANVAS --


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
