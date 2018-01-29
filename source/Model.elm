module Model exposing (Model)

import Canvas exposing (Canvas, DrawOp, Point, Size)
import Data.Color
import Data.Config exposing (Config)
import Data.History
import Data.Menu as Menu
import Data.Minimap as Minimap
import Data.Project exposing (Project)
import Data.Taskbar exposing (Dropdown)
import Data.Tool exposing (Tool)
import Data.User exposing (User)
import Id exposing (Id)
import Mouse exposing (Position)
import Random.Pcg as Random exposing (Seed)


type alias Model =
    { user : Data.User.Model
    , canvas : Canvas
    , color : Data.Color.Model
    , project : Project
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
