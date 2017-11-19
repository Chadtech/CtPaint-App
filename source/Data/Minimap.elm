module Data.Minimap
    exposing
        ( ClickState(..)
        , Model
        , MouseHappening(..)
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
    | NoClicks


type Reply
    = Close
    | NoReply


type Msg
    = CloseClick
    | ZoomInClicked
    | ZoomOutClicked
    | MouseDidSomething MouseHappening


type MouseHappening
    = HeaderMouseDown MouseEvent
    | ScreenMouseDown MouseEvent
    | MouseMoved Position
    | MouseUp
