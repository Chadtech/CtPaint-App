module Main.Model exposing (Model)

import Types.Session as Session exposing (Session)
import Tool.Types exposing (Tool(..))
import ColorPicker.Types as ColorPicker
import Canvas exposing (Canvas, Size, DrawOp(..))
import Color exposing (Color)
import Main.Message exposing (Message(..))
import Mouse exposing (Position)
import Palette.Types exposing (Swatches)
import Array exposing (Array)
import History.Types exposing (HistoryOp(..))
import List.Unique exposing (UniqueList)
import Keyboard exposing (KeyCode)
import Keyboard.Types as Keyboard
import Taskbar.Types as Taskbar
import Minimap.Types as Minimap
import Types.Menu exposing (Menu(..))
import Random exposing (Seed)
import Dict exposing (Dict)


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
