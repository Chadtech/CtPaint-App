module PaintApp exposing (..)

import Canvas exposing (Canvas, DrawOp(..), Point, Size)
import Data.Color
import Data.Config as Config
import Data.Flags as Flags exposing (Flags)
import Data.History
import Data.Menu as Menu
import Data.Minimap
import Data.Project as Project
import Data.Tool as Tool
import Data.User as User
import Data.Window as Window
import Dict
import Helpers.Canvas as Canvas
import Html
import Id exposing (Id, Origin(Local))
import Json.Decode as Decode exposing (Decoder, Value, value)
import Keyboard.Extra.Browser exposing (Browser(FireFox))
import Menu
import Model exposing (Model)
import Msg exposing (Msg(..))
import Ports exposing (JsMsg(RedirectPageTo))
import Random.Pcg as Random
import Subscriptions exposing (subscriptions)
import Tracking exposing (Event(AppFailedToInitialize, AppLoaded))
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
        ( menu, menuCmd ) =
            getInitialMenu flags

        canvasSize =
            Canvas.getSize Canvas.blank
    in
    { user = flags.user
    , canvas = Canvas.blank
    , color = Data.Color.init
    , project = Project.init flags.randomValues.projectName
    , canvasPosition =
        { x =
            ((flags.windowSize.width - tbw) - canvasSize.width) // 2
        , y =
            (flags.windowSize.height - canvasSize.height) // 2
        }
    , pendingDraw = Canvas.noop
    , drawAtRender = Canvas.noop
    , windowSize = flags.windowSize
    , tool = Tool.init
    , zoom = 1
    , galleryView = False
    , history = Data.History.init Canvas.blank
    , mousePosition = Nothing
    , selection = Nothing
    , clipboard = Nothing
    , taskbarDropped = Nothing
    , minimap = Data.Minimap.NotInitialized
    , menu = menu
    , seed = flags.randomValues.seed
    , eraserSize = 5
    , shiftIsDown = False
    , config = Config.init flags
    }
        |> withCmd


withCmd : Model -> ( Model, Cmd Msg )
withCmd model =
    [ Ports.track
        { event = AppLoaded
        , sessionId = model.config.sessionId
        , email = User.getEmail model.user
        , projectId = Nothing
        }
    ]
        |> Cmd.batch
        |& model


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
    let
        cmd =
            { event = AppFailedToInitialize err
            , sessionId = Id.fromString ""
            , email = Nothing
            , projectId = Nothing
            }
                |> Ports.Track
                |> Ports.send
    in
    { user = User.LoggedOut
    , canvas =
        Canvas.initialize
            { width = 400
            , height = 400
            }
    , color = Data.Color.init
    , project =
        { name = ""
        , nameIsGenerated = False
        , origin = Local
        }
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
        , buildNumber = ""
        , browser = FireFox
        , sessionId = Id.fromString ""
        }
    }
        & cmd
