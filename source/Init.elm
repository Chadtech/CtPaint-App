module Init exposing (Error(..), fromFlags, init)

import Canvas exposing (Canvas, DrawOp(..), Point, Size)
import Data.Color
import Data.Flags as Flags exposing (Flags, Init(..))
import Data.History
import Data.Menu as Menu
import Data.Minimap
import Data.Taco as Taco
import Data.Tool as Tool
import Data.User as User
import Data.Window as Window
import Helpers.Canvas as Canvas
import Helpers.Import
import Id exposing (Origin(Local, Remote))
import Json.Decode as Decode exposing (Value)
import Menu
import Model exposing (Model)
import Mouse exposing (Position)
import Msg exposing (Msg(InitFromUrl))
import Ports exposing (JsMsg(LoadDrawing, RedirectPageTo))
import Return2 as R2
import Tracking exposing (Event(AppInit, AppInitFail))
import Util exposing (tbw)


-- TYPES --


type Error
    = AllowanceExceeded
    | Other String


init : Value -> ( Result Error Model, Cmd Msg )
init json =
    case Decode.decodeValue Flags.decoder json of
        Ok flags ->
            case flags.user of
                User.AllowanceExceeded ->
                    [ Window.AllowanceExceeded
                        |> Window.toUrl flags.mountPath
                        |> RedirectPageTo
                        |> Ports.send
                    , Ports.track
                        (Taco.fromFlags flags)
                        Tracking.AllowanceExceed
                    ]
                        |> Cmd.batch
                        |> R2.withModel
                            (Err AllowanceExceeded)

                _ ->
                    fromFlags flags
                        |> Tuple.mapFirst Ok

        Err err ->
            Err (Other err)
                |> R2.withCmd (errCmd err)


errCmd : String -> Cmd Msg
errCmd err =
    { sessionId = Id.fromString "ERROR"
    , email = Nothing
    , event = AppInitFail err
    }
        |> Ports.Track
        |> Ports.send


fromFlags : Flags -> ( Model, Cmd Msg )
fromFlags flags =
    let
        fields =
            getFields flags

        canvasSize =
            Canvas.getSize fields.canvas
    in
    { canvas = fields.canvas
    , color = fields.color
    , canvasPosition = fields.canvasPosition
    , drawingName = fields.drawingName
    , drawingNameIsGenerated = fields.drawingNameIsGenerated
    , pendingDraw = Canvas.noop
    , drawAtRender = Canvas.noop
    , windowSize = flags.windowSize
    , tool = Tool.init
    , zoom = 1
    , galleryView = False
    , history = Data.History.init fields.canvas
    , mousePosition = Nothing
    , selection = Nothing
    , clipboard = Nothing
    , taskbarDropped = Nothing
    , minimap = Data.Minimap.NotInitialized
    , menu = fields.menu
    , seed = flags.randomValues.seed
    , eraserSize = 5
    , shiftIsDown = False
    , taco = Taco.fromFlags flags
    }
        |> R2.withCmd fields.cmd
        |> withTracking


withTracking : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
withTracking ( model, cmd ) =
    [ { windowSize = model.windowSize
      , isMac = model.taco.config.isMac
      , browser = model.taco.config.browser
      , buildNumber = model.taco.config.buildNumber
      , drawingId = User.getDrawingOrigin model.taco.user
      }
        |> AppInit
        |> Ports.track model.taco
    , cmd
    ]
        |> Cmd.batch
        |> R2.withModel model


type alias InitFields =
    { canvas : Canvas
    , canvasPosition : Position
    , drawingName : String
    , drawingNameIsGenerated : Bool
    , id : Origin
    , menu : Maybe Menu.Model
    , cmd : Cmd Msg
    , color : Data.Color.Model
    }


getFields : Flags -> InitFields
getFields ({ windowSize } as flags) =
    case flags.init of
        NormalInit ->
            let
                size =
                    Canvas.getSize Canvas.blank
            in
            { canvas = Canvas.blank
            , canvasPosition =
                Util.center flags.windowSize size
            , drawingName = flags.randomValues.projectName
            , drawingNameIsGenerated = True
            , id = Local
            , menu =
                Menu.initNew
                    flags.randomValues.projectName
                    flags.windowSize
                    |> Just
            , cmd = Ports.stealFocus
            , color = Data.Color.init
            }

        FromId id ->
            { canvas = Canvas.tiny
            , canvasPosition = offScreen
            , drawingName = "loading"
            , drawingNameIsGenerated = False
            , id = Remote id
            , menu =
                Menu.initLoading
                    Nothing
                    flags.windowSize
                    |> Just
            , cmd = Ports.send (LoadDrawing id)
            , color = Data.Color.init
            }

        FromUrl url ->
            { canvas = Canvas.tiny
            , canvasPosition = offScreen
            , drawingName = flags.randomValues.projectName
            , drawingNameIsGenerated = True
            , id = Local
            , menu =
                Menu.initLoading
                    (Just url)
                    flags.windowSize
                    |> Just
            , cmd = Helpers.Import.loadCmd url InitFromUrl
            , color = Data.Color.init
            }

        FromParams params ->
            let
                canvas =
                    Canvas.fromParams params

                size =
                    Canvas.getSize canvas
            in
            { canvas = canvas
            , canvasPosition =
                Util.center flags.windowSize size
            , drawingName =
                params.name
                    |> Maybe.withDefault flags.randomValues.projectName
            , drawingNameIsGenerated = params.name /= Nothing
            , id = Local
            , menu = Nothing
            , cmd = Cmd.none
            , color = Data.Color.init
            }


offScreen : Position
offScreen =
    { x = -100, y = -100 }
