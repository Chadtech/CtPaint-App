module Main.Model exposing (Model)

import Array exposing (Array)
import Canvas exposing (Canvas, DrawOp(..), Size)
import Color exposing (Color)
import ColorPicker.Types as ColorPicker
import Dict exposing (Dict)
import History.Types exposing (HistoryOp(..))
import Keyboard exposing (KeyCode)
import Keyboard.Types as Keyboard
import List.Unique exposing (UniqueList)
import Main.Message exposing (Message(..))
import Minimap.Types as Minimap
import Mouse exposing (Position)
import Palette.Types exposing (Swatches)
import Random exposing (Seed)
import Taskbar.Types as Taskbar
import Tool.Types exposing (Tool(..))
import Types.Menu exposing (Menu(..))
import Types.Session as Session exposing (Session)


type alias Model =
    { session : Maybe Session
    , canvas : Canvas
    , projectName : Maybe String
    , canvasPosition : Position
    , pendingDraw : DrawOp
    , drawAtRender : DrawOp
    , swatches : Swatches
    , palette : Array Color
    , horizontalToolbarHeight : Int
    , subMouseMove : Maybe (Position -> Message)
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
    , keysDown : UniqueList KeyCode
    , keyboardUpConfig : Keyboard.Config
    , keyboardUpLookUp : Dict String (List String)
    , keyboardDownConfig : Keyboard.Config
    , keyboardDownLookUp : Dict String (List String)
    , taskbarDropped : Maybe Taskbar.Option
    , minimap : Maybe Minimap.Model
    , menu : Menu
    , seed : Seed
    }
