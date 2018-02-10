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
import Error
import Helpers.Canvas as Canvas
import Html exposing (Html)
import Json.Decode as Decode exposing (Decoder, Value, value)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Ports exposing (JsMsg(RedirectPageTo))
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
            fromFlags flags
                |> Tuple.mapFirst Ok

        Err err ->
            Err err & Cmd.none


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
