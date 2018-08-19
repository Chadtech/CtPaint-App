module Init exposing (Error(..), fromFlags, init)

import Canvas exposing (Canvas, DrawOp(..), Point, Size)
import Canvas.Data.Params
import Canvas.Draw.Model
import Canvas.Helpers
import Canvas.Model
import Color.Model
import Data.Config as Config
import Data.Flags as Flags exposing (Flags, Init(..))
import Data.Position as Position exposing (Position)
import Data.Size as Size
import Data.User as User
import Data.Window as Window
import Helpers.Import
import History.Model as History
import Id exposing (Origin(Local, Remote))
import Json.Decode as Decode exposing (Value)
import Menu.Model as Menu
import Minimap.Model as Minimap
import Model exposing (Model)
import Msg exposing (Msg(InitFromUrl))
import Ports exposing (JsMsg(LoadDrawing, RedirectPageTo))
import Return2 as R2
import Tool.Data as Tool


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
                    Window.AllowanceExceeded
                        |> Window.toUrl flags.mountPath
                        |> RedirectPageTo
                        |> Ports.send
                        |> R2.withModel
                            (Err AllowanceExceeded)

                _ ->
                    fromFlags flags
                        |> Tuple.mapFirst Ok

        Err err ->
            Err (Other err)
                -- TODO
                -- App INit Error tracking
                |> R2.withNoCmd


fromFlags : Flags -> ( Model, Cmd Msg )
fromFlags flags =
    let
        ( fields, cmd ) =
            getFields flags
    in
    { canvas = fields.canvas
    , draws = Canvas.Draw.Model.init
    , color = Color.Model.init
    , drawingName = fields.drawingName
    , drawingNameIsGenerated = fields.drawingNameIsGenerated
    , tool = Tool.init
    , zoom = 1
    , galleryView = False
    , history = History.init fields.canvas.main
    , mousePosition = Nothing
    , selection = Nothing
    , clipboard = Nothing
    , taskbarDropped = Nothing
    , minimap = Minimap.init (Canvas.getSize fields.canvas.main)
    , menu = fields.menu
    , seed = flags.randomValues.seed
    , eraserSize = 5
    , shiftIsDown = False
    , windowSize = flags.windowSize
    , user = flags.user
    , config = Config.init flags
    }
        |> R2.withCmd cmd


type alias InitFields =
    { canvas : Canvas.Model.Model
    , drawingName : String
    , drawingNameIsGenerated : Bool
    , id : Origin
    , menu : Maybe Menu.Model
    }


getFields : Flags -> ( InitFields, Cmd Msg )
getFields ({ windowSize } as flags) =
    case flags.init of
        NormalInit ->
            { canvas =
                { main = Canvas.Helpers.blank
                , position =
                    Size.centerIn
                        flags.windowSize
                        (Canvas.getSize Canvas.Helpers.blank)
                }
            , drawingName = flags.randomValues.projectName
            , drawingNameIsGenerated = True
            , id = Local
            , menu =
                Menu.initNew
                    flags.randomValues.projectName
                    flags.windowSize
                    |> Just
            }
                |> R2.withCmd Ports.stealFocus

        FromId id ->
            { canvas =
                { main = Canvas.Helpers.tiny
                , position = offScreen
                }
            , drawingName = "loading"
            , drawingNameIsGenerated = False
            , id = Remote id
            , menu =
                Menu.initLoading
                    Nothing
                    flags.windowSize
                    |> Just
            }
                |> R2.withCmd
                    (Ports.send (LoadDrawing id))

        FromUrl url ->
            { canvas =
                { main = Canvas.Helpers.tiny
                , position = offScreen
                }
            , drawingName = flags.randomValues.projectName
            , drawingNameIsGenerated = True
            , id = Local
            , menu =
                Menu.initLoading
                    (Just url)
                    flags.windowSize
                    |> Just
            }
                |> R2.withCmd
                    (Helpers.Import.loadCmd url InitFromUrl)

        FromParams params ->
            let
                canvas =
                    Canvas.Data.Params.toCanvas params
            in
            { canvas =
                { main = canvas
                , position =
                    Size.centerIn
                        flags.windowSize
                        (Canvas.getSize canvas)
                }
            , drawingName =
                params.name
                    |> Maybe.withDefault flags.randomValues.projectName
            , drawingNameIsGenerated = params.name /= Nothing
            , id = Local
            , menu = Nothing
            }
                |> R2.withNoCmd


offScreen : Position
offScreen =
    { x = -100, y = -100 }
