module Types exposing (..)

import Array exposing (Array)
import Canvas exposing (Canvas, DrawOp(..), Point, Size)
import Color exposing (Color)
import ColorPicker
import Data.Config exposing (Config)
import Data.Menu as Menu
import Data.Palette exposing (Swatches)
import Data.Taskbar exposing (Dropdown)
import Data.Tool exposing (Tool(..))
import Data.User exposing (User)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline
    exposing
        ( decode
        , required
        , requiredAt
        )
import Minimap
import Mouse exposing (Position)
import Random exposing (Seed)


-- TYPES --


type alias Model =
    { user : Maybe User
    , canvas : Canvas
    , projectName : Maybe String
    , canvasPosition : Position
    , pendingDraw : DrawOp
    , drawAtRender : DrawOp
    , swatches : Swatches
    , palette : Array Color
    , horizontalToolbarHeight : Int
    , windowSize : Size
    , tool : Tool
    , zoom : Int
    , galleryView : Bool
    , colorPicker : ColorPicker.Model
    , history : List HistoryOp
    , future : List HistoryOp
    , mousePosition : Maybe Position
    , selection : Maybe ( Position, Canvas )
    , clipboard : Maybe ( Position, Canvas )
    , taskbarDropped : Maybe Dropdown
    , minimap : MinimapState
    , menu : Maybe Menu.Model
    , seed : Seed
    , config : Config
    }


type MinimapState
    = NoMinimap
    | Minimap Minimap.Model
    | Closed Position


type NewWindow
    = Preferences
    | Tutorial
    | Donate



-- KeyEvent --


type HistoryOp
    = CanvasChange Canvas
    | ColorChange Int Color



-- WINDOW --


toUrl : NewWindow -> String
toUrl window =
    case window of
        Preferences ->
            "https://www.twitter.com"

        Tutorial ->
            "https://www.twitter.com"

        Donate ->
            "https://www.twitter.com"



-- INIT CANVAS --


decodeCanvas : Value -> Result String Canvas
decodeCanvas json =
    json
        |> Decode.decodeValue canvasDecoder


canvasDecoder : Decoder Canvas
canvasDecoder =
    decode toCanvas
        |> requiredAt
            [ "canvas", "size", "width" ]
            Decode.int
        |> requiredAt
            [ "canvas", "size", "height" ]
            Decode.int
        |> requiredAt
            [ "canvas", "data" ]
            Decode.string


toCanvas : Int -> Int -> String -> Canvas
toCanvas width height data =
    let
        size =
            { width = width
            , height = height
            }
    in
    Canvas.initialize size
        |> fillBlack


fillBlack : Canvas -> Canvas
fillBlack canvas =
    Canvas.draw (fillBlackOp canvas) canvas


fillBlackOp : Canvas -> DrawOp
fillBlackOp canvas =
    [ BeginPath
    , Rect (Point 0 0) (Canvas.getSize canvas)
    , FillStyle Color.black
    , Canvas.Fill
    ]
        |> Canvas.batch
