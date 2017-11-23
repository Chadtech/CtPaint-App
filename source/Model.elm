module Model exposing (Model)

import Array exposing (Array)
import Canvas exposing (Canvas, DrawOp, Point, Size)
import Color exposing (Color)
import ColorPicker
import Data.Config exposing (Config)
import Data.History
import Data.Menu as Menu
import Data.Minimap as Minimap
import Data.Palette exposing (Swatches)
import Data.Project exposing (Project)
import Data.Taskbar exposing (Dropdown)
import Data.Tool exposing (Tool)
import Data.User exposing (User)
import Mouse exposing (Position)
import Random exposing (Seed)


-- TYPES --


type alias Model =
    { user : Data.User.Model
    , canvas : Canvas
    , project : Maybe Project
    , canvasPosition : Position
    , pendingDraw : DrawOp
    , drawAtRender : DrawOp
    , swatches : Swatches
    , palette : Array Color
    , horizontalToolbarHeight : Int
    , windowSize : Size
    , tool : Tool
    , zoom : Int
    , galleryView : Bool
    , colorPicker : ColorPicker.Model
    , history : Data.History.Model
    , mousePosition : Maybe Position
    , selection : Maybe ( Position, Canvas )
    , clipboard : Maybe ( Position, Canvas )
    , taskbarDropped : Maybe Dropdown
    , minimap : Minimap.State
    , menu : Maybe Menu.Model
    , seed : Seed
    , config : Config
    }
