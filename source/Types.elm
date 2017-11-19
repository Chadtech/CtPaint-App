module Types exposing (..)

import Array exposing (Array)
import Canvas exposing (Canvas, DrawOp(..), Point, Size)
import Color exposing (Color)
import ColorPicker
import Data.Config exposing (Config)
import Data.Menu as Menu
import Data.Minimap as Minimap
import Data.Palette exposing (Swatches)
import Data.Taskbar exposing (Dropdown)
import Data.Tool exposing (Tool(..))
import Data.User exposing (User)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Decode.Pipeline
    exposing
        ( decode
        , required
        , requiredAt
        )
import Minimap
import Mouse exposing (Position)
import Random exposing (Seed)


-- TYPES --


type alias Model =
    { user : Maybe User
    , canvas : Canvas
    , projectName : Maybe String
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
    , history : List HistoryOp
    , future : List HistoryOp
    , mousePosition : Maybe Position
    , selection : Maybe ( Position, Canvas )
    , clipboard : Maybe ( Position, Canvas )
    , taskbarDropped : Maybe Dropdown
    , minimap : Minimap.State
    , menu : Maybe Menu.Model
    , seed : Seed
    , config : Config
    }



-- KeyEvent --


type HistoryOp
    = CanvasChange Canvas
    | ColorChange Int Color
