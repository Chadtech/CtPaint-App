module PaintApp exposing (..)

import Array exposing (Array)
import Canvas exposing (Canvas, DrawOp(..), Point, Size)
import Color
import ColorPicker
import Data.Config as Config
import Data.Flags as Flags exposing (Flags)
import Data.History
import Data.Menu as Menu
import Data.Minimap
import Data.Palette exposing (initPalette, initSwatches)
import Data.User
import Dict
import Html
import Json.Decode as Decode exposing (Decoder, Value, value)
import Menu
import Model exposing (Model)
import Msg exposing (Msg(..))
import Random
import Subscriptions exposing (subscriptions)
import Tool
import Tuple.Infix exposing ((&))
import Update exposing (update)
import Util exposing (tbw)
import View exposing (view)


-- MAIN --


main : Program Value Model Msg
main =
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
        |> Html.programWithFlags



-- INIT --


init : Value -> ( Model, Cmd Msg )
init json =
    case Decode.decodeValue Flags.decoder json of
        Ok flags ->
            fromFlags flags

        Err err ->
            fromError err


fromFlags : Flags -> ( Model, Cmd Msg )
fromFlags flags =
    let
        canvas =
            { width = 400
            , height = 400
            }
                |> Canvas.initialize
                |> fillBlack

        canvasSize : Size
        canvasSize =
            Canvas.getSize canvas

        ( menu, cmd ) =
            getInitialMenu flags
    in
    { user = flags.user
    , canvas = canvas
    , project = Nothing
    , canvasPosition =
        { x =
            ((flags.windowSize.width - tbw) - canvasSize.width) // 2
        , y =
            (flags.windowSize.height - canvasSize.height) // 2
        }
    , pendingDraw = Canvas.batch []
    , drawAtRender = Canvas.batch []
    , swatches = initSwatches
    , palette = initPalette
    , horizontalToolbarHeight = 58
    , windowSize = flags.windowSize
    , tool = Tool.init
    , zoom = 1
    , galleryView = False
    , colorPicker =
        case Array.get 0 initPalette of
            Just color ->
                ColorPicker.init
                    False
                    0
                    color

            Nothing ->
                ColorPicker.init
                    False
                    0
                    Color.black
    , history = Data.History.init canvas
    , mousePosition = Nothing
    , selection = Nothing
    , clipboard = Nothing
    , taskbarTitle = Nothing
    , taskbarDropped = Nothing
    , minimap = Data.Minimap.NotInitialized
    , menu = menu
    , seed = flags.seed
    , config = Config.init flags
    }
        & cmd


getInitialMenu : Flags -> ( Maybe Menu.Model, Cmd Msg )
getInitialMenu { localWork } =
    ( Nothing, Cmd.none )


fromError : String -> ( Model, Cmd Msg )
fromError err =
    { user = Data.User.NoSession
    , canvas =
        Canvas.initialize
            { width = 400
            , height = 400
            }
    , project = Nothing
    , canvasPosition = { x = 0, y = 0 }
    , pendingDraw = Canvas.batch []
    , drawAtRender = Canvas.batch []
    , swatches = initSwatches
    , palette = initPalette
    , horizontalToolbarHeight = 58
    , windowSize = { width = 0, height = 0 }
    , tool = Tool.init
    , zoom = 1
    , galleryView = False
    , colorPicker =
        case Array.get 0 initPalette of
            Just color ->
                ColorPicker.init
                    False
                    0
                    color

            Nothing ->
                ColorPicker.init
                    False
                    0
                    Color.black
    , history =
        { past = []
        , future = []
        }
    , mousePosition = Nothing
    , selection = Nothing
    , clipboard = Nothing
    , taskbarTitle = Nothing
    , taskbarDropped = Nothing
    , minimap = Data.Minimap.NotInitialized
    , menu =
        { width = 800, height = 800 }
            |> Menu.initError err
            |> Just
    , seed = Random.initialSeed 0
    , config =
        { keyCmds = Dict.empty
        , quickKeys = Dict.empty
        , cmdKey = always False
        , mountPath = ""
        }
    }
        & Cmd.none



-- FILL BLACK --


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
