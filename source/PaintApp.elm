module PaintApp exposing (..)

import Canvas exposing (Canvas, DrawOp(..), Point, Size)
import Color
import Data.Color
import Data.Config as Config
import Data.Flags as Flags exposing (Flags)
import Data.History
import Data.Id as Id exposing (Id)
import Data.Menu as Menu
import Data.Minimap
import Data.Project exposing (Project)
import Data.Tool as Tool
import Data.User as User
import Data.Window as Window
import Dict
import Html
import Json.Decode as Decode exposing (Decoder, Value, value)
import Menu
import Model exposing (Model)
import Msg exposing (Msg(..))
import Ports exposing (JsMsg(RedirectPageTo))
import Random.Pcg as Random
import Subscriptions exposing (subscriptions)
import Tracking exposing (Event(AppLoaded))
import Tuple.Infix exposing ((&), (|&))
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

        ( menu, menuCmd ) =
            getInitialMenu flags

        cmd : Cmd Msg
        cmd =
            [ menuCmd
            , Ports.track
                { event = AppLoaded
                , sessionId = sessionId
                , email = User.getEmail flags.user
                , projectId = Nothing
                }
            ]
                |> Cmd.batch

        project : Maybe Project
        project =
            Nothing

        ( sessionId, seed ) =
            Util.uuid flags.seed 64
                |> Tuple.mapFirst Id.fromString
    in
    { user = flags.user
    , sessionId = sessionId
    , canvas = canvas
    , color = Data.Color.init
    , project = project
    , canvasPosition =
        { x =
            ((flags.windowSize.width - tbw) - canvasSize.width) // 2
        , y =
            (flags.windowSize.height - canvasSize.height) // 2
        }
    , pendingDraw = Canvas.batch []
    , drawAtRender = Canvas.batch []
    , windowSize = flags.windowSize
    , tool = Tool.init
    , zoom = 1
    , galleryView = False
    , history = Data.History.init canvas
    , mousePosition = Nothing
    , selection = Nothing
    , clipboard = Nothing
    , taskbarTitle = Nothing
    , taskbarDropped = Nothing
    , minimap = Data.Minimap.NotInitialized
    , menu = menu
    , seed = flags.seed
    , eraserSize = 9
    , shiftIsDown = False
    , config = Config.init flags
    }
        & cmd


type alias InitBehavior =
    ( Maybe Menu.Model, Cmd Msg )


getInitialMenu : Flags -> InitBehavior
getInitialMenu flags =
    [ checkUser ]
        |> checkConditions flags


checkConditions : Flags -> List (Flags -> Maybe InitBehavior) -> InitBehavior
checkConditions flags conditions =
    case conditions of
        [] ->
            ( Nothing, Cmd.none )

        first :: rest ->
            case first flags of
                Just behavior ->
                    behavior

                Nothing ->
                    checkConditions flags rest


checkUser : Flags -> Maybe InitBehavior
checkUser flags =
    case flags.user of
        User.AllowanceExceeded ->
            Window.AllowanceExceeded
                |> Window.toUrl flags.mountPath
                |> RedirectPageTo
                |> Ports.send
                |& Nothing
                |> Just

        _ ->
            Nothing


fromError : String -> ( Model, Cmd Msg )
fromError err =
    { user = User.LoggedOut
    , sessionId = Id.fromString ""
    , canvas =
        Canvas.initialize
            { width = 400
            , height = 400
            }
    , color = Data.Color.init
    , project = Nothing
    , canvasPosition = { x = 0, y = 0 }
    , pendingDraw = Canvas.batch []
    , drawAtRender = Canvas.batch []
    , windowSize = { width = 0, height = 0 }
    , tool = Tool.init
    , zoom = 1
    , galleryView = False
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
    , eraserSize = 1
    , shiftIsDown = False
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
