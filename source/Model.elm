module Model exposing (Model, toSavePayload, updateCanvas)

import Canvas exposing (Canvas, DrawOp, Point, Size)
import Data.Color as Color
import Data.Config exposing (Config)
import Data.Drawing as Drawing
import Data.History as History
import Data.Menu as Menu
import Data.Minimap as Minimap
import Data.Selection as Selection
import Data.Taskbar exposing (Dropdown)
import Data.Tool exposing (Tool)
import Data.User as User
import Mouse exposing (Position)
import Ports exposing (SavePayload)
import Random.Pcg as Random exposing (Seed)


type alias Model =
    { user : User.State
    , canvas : Canvas
    , color : Color.Model
    , drawingName : String
    , drawingNameIsGenerated : Bool
    , canvasPosition : Position
    , pendingDraw : DrawOp
    , drawAtRender : DrawOp
    , windowSize : Size
    , tool : Tool
    , zoom : Int
    , galleryView : Bool
    , history : History.Model
    , mousePosition : Maybe Position
    , selection : Maybe Selection.Model
    , clipboard : Maybe ( Position, Canvas )
    , taskbarDropped : Maybe Dropdown
    , minimap : Minimap.State
    , menu : Maybe Menu.Model
    , seed : Seed
    , eraserSize : Int
    , shiftIsDown : Bool
    , config : Config
    }



-- HELPERS --


updateCanvas : (Canvas -> Canvas) -> Model -> Model
updateCanvas f model =
    { model | canvas = f model.canvas }


toSavePayload : Model -> Maybe SavePayload
toSavePayload model =
    case model.user of
        User.LoggedIn { user, drawing } ->
            { canvas = model.canvas
            , name = model.drawingName
            , nameIsGenerated = model.drawingNameIsGenerated
            , palette = model.color.palette
            , swatches = model.color.swatches
            , email = user.email
            , id = Drawing.toOrigin drawing
            }
                |> Just

        _ ->
            Nothing
