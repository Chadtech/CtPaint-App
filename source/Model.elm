module Model exposing (Model, toSavePayload)

import Canvas exposing (Canvas, DrawOp, Point, Size)
import Data.Color
import Data.Config exposing (Config)
import Data.History
import Data.Menu as Menu
import Data.Minimap as Minimap
import Data.Taskbar exposing (Dropdown)
import Data.Tool exposing (Tool)
import Data.User as User
import Mouse exposing (Position)
import Ports exposing (SavePayload)
import Random.Pcg as Random exposing (Seed)


type alias Model =
    { user : User.State
    , canvas : Canvas
    , color : Data.Color.Model
    , drawingName : String
    , drawingNameIsGenerated : Bool
    , canvasPosition : Position
    , pendingDraw : DrawOp
    , drawAtRender : DrawOp
    , windowSize : Size
    , tool : Tool
    , zoom : Int
    , galleryView : Bool
    , history : Data.History.Model
    , mousePosition : Maybe Position
    , selection : Maybe ( Position, Canvas )
    , clipboard : Maybe ( Position, Canvas )
    , taskbarDropped : Maybe Dropdown
    , minimap : Minimap.State
    , menu : Maybe Menu.Model
    , seed : Seed
    , eraserSize : Int
    , shiftIsDown : Bool
    , config : Config
    }


toSavePayload : Model -> Maybe SavePayload
toSavePayload model =
    case model.user of
        User.LoggedIn { user, drawingId } ->
            { canvas = model.canvas
            , name = model.drawingName
            , nameIsGenerated = model.drawingNameIsGenerated
            , palette = model.color.palette
            , swatches = model.color.swatches
            , email = user.email
            , id = drawingId
            }
                |> Just

        _ ->
            Nothing
