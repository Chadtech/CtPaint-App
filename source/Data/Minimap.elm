module Data.Minimap
    exposing
        ( ClickState(..)
        , Model
        , Msg(..)
        , Reply(..)
        , State(..)
        )

import Mouse exposing (Position)
import MouseEvents exposing (MouseEvent)


type State
    = NotInitialized
    | Closed Position
    | Opened Model


type alias Model =
    { externalPosition : Position
    , internalPosition : Position
    , zoom : Int
    , clickState : ClickState
    }


type ClickState
    = ClickedInHeaderAt Position
    | ClickedInScreenAt Position
    | XButtonIsDown
    | NoClicks


type Reply
    = Close
    | NoReply


type Msg
    = XButtonMouseDown
    | XButtonMouseUp
    | ZoomInClicked
    | ZoomOutClicked
    | ZeroClicked
    | HeaderMouseDown MouseEvent
    | ScreenMouseDown MouseEvent
    | MouseMoved Position
    | MouseUp
