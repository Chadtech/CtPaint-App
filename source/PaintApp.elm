module PaintApp exposing (..)

import Canvas exposing (Canvas, DrawOp(..), Point, Size)
import Data.Color
import Data.Config as Config
import Data.Flags as Flags exposing (Flags, Init(..))
import Data.History
import Data.Menu as Menu
import Data.Minimap
import Data.Project as Project exposing (Project)
import Data.Tool as Tool
import Data.User as User
import Data.Window as Window
import Error
import Helpers.Canvas as Canvas
import Helpers.Import
import Html exposing (Html)
import Id exposing (Origin(Local, Remote))
import Json.Decode as Decode exposing (Decoder, Value, value)
import Menu
import Model exposing (Model)
import Mouse exposing (Position)
import Msg exposing (Msg(..))
import Ports exposing (JsMsg(LoadDrawing, RedirectPageTo))
import Subscriptions exposing (subscriptions)
import Tracking exposing (Event(AppFailedToInitialize, AppLoaded))
import Tuple.Infix exposing ((&), (|&))
import Update
import Util exposing (tbw)
import View


-- MAIN --


main : Program Value (Result String Model) Msg
main =
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
        |> Html.programWithFlags



-- VIEW --


view : Result String Model -> Html Msg
view result =
    case result of
        Ok model ->
            View.view model

        Err err ->
            Error.view err



-- UPDATE --


update : Msg -> Result String Model -> ( Result String Model, Cmd Msg )
update msg result =
    case result of
        Ok model ->
            Update.update msg model
                |> Tuple.mapFirst Ok

        Err err ->
            Err err & Cmd.none



-- INIT --


init : Value -> ( Result String Model, Cmd Msg )
init json =
    case Decode.decodeValue Flags.decoder json of
        Ok flags ->
            case flags.user of
                User.AllowanceExceeded ->
                    Window.AllowanceExceeded
                        |> Window.toUrl flags.mountPath
                        |> RedirectPageTo
                        |> Ports.send
                        |& Err "allowance exceeded"

                _ ->
                    fromFlags flags
                        |> Tuple.mapFirst Ok

        Err err ->
            Err err & Cmd.none


fromFlags : Flags -> ( Model, Cmd Msg )
fromFlags flags =
    let
        fields =
            getFields flags

        canvasSize =
            Canvas.getSize fields.canvas
    in
    { user = flags.user
    , canvas = fields.canvas
    , color = fields.color
    , project = fields.project
    , canvasPosition = fields.canvasPosition
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
    , config = Config.init flags
    }
        & fields.cmd
        |> withTracking


withTracking : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
withTracking ( model, cmd ) =
    [ Ports.track
        { event = AppLoaded
        , sessionId = model.config.sessionId
        , email = User.getEmail model.user
        , projectId =
            case model.project.origin of
                Remote id ->
                    Just id

                Local ->
                    Nothing
        }
    , cmd
    ]
        |> Cmd.batch
        |& model


type alias InitFields =
    { canvas : Canvas
    , canvasPosition : Position
    , project : Project
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
            , project =
                flags.randomValues.projectName
                    |> Project.init
            , menu = Nothing
            , cmd = Cmd.none
            , color = Data.Color.init
            }

        FromId id ->
            { canvas = Canvas.tiny
            , canvasPosition = offScreen
            , project = Project.loading id
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
            , project =
                flags.randomValues.projectName
                    |> Project.init
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
            , project =
                case params.name of
                    Just name ->
                        Project.init name

                    Nothing ->
                        flags.randomValues.projectName
                            |> Project.init
            , menu = Nothing
            , cmd = Cmd.none
            , color = Data.Color.init
            }


offScreen : Position
offScreen =
    { x = -100, y = -100 }
