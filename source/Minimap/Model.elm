module Minimap.Model
    exposing
        ( ClickState(..)
        , Model
        , OpenModel
        , OpenState(..)
        , applyTo
        , applyToOpenModel
        , close
        , init
        , setCanvasPosition
        , setCardPosition
        , setClickState
        , setOpenState
        , toggleOpen
        , zoomIn
        , zoomOut
        )

import Data.Size as Size exposing (Size)
import Minimap.Constants
import Data.Position as Position exposing (Position)
import Tool.Zoom as Zoom


-- TYPES --


type alias Model =
    { canvasPosition : Position
    , zoom : Int
    , openState : OpenState
    }


type OpenState
    = Open OpenModel
    | Closed Position


type alias OpenModel =
    { position : Position
    , clickState : ClickState
    }


type ClickState
    = ClickedInHeaderAt Position
    | ClickedInMinimapAt Position
    | XButtonIsDown
    | NoClicks


init : Size -> Model
init canvasSize =
    { canvasPosition =
        Size.centerIn
            Minimap.Constants.portalSize
            canvasSize
    , zoom = 1
    , openState =
        { x = 550
        , y = 550
        }
            |> Closed
    }



-- HELPERS --


applyTo : Model -> (Model -> Model) -> Model
applyTo model f =
    f model


applyToOpenModel : OpenModel -> (OpenModel -> OpenModel) -> OpenModel
applyToOpenModel openModel f =
    f openModel


toggleOpen : Size -> Model -> Model
toggleOpen windowSize model =
    case model.openState of
        Open openModel ->
            close windowSize openModel model

        -- This closed position is relative to the
        -- lower right corner, not the upper left
        --
        -- This is so that the position can be stored
        -- in a meaningful way even if the window size
        -- changes while the minimap is closed
        Closed position ->
            { model
                | openState =
                    { position =
                        windowSize
                            |> Size.toPosition
                            |> Position.subtract position
                    , clickState = NoClicks
                    }
                        |> Open
            }


close : Size -> OpenModel -> Model -> Model
close windowSize openModel model =
    { model
        | openState =
            windowSize
                |> Size.toPosition
                |> Position.subtract openModel.position
                |> Closed
    }


zoomOut : Model -> Model
zoomOut model =
    let
        newZoom =
            Zoom.nextLevelOut model.zoom

        newCanvasPosition =
            Zoom.zoom
                model.zoom
                newZoom
                Minimap.Constants.centerOfPortal
                model.canvasPosition
    in
    { model
        | canvasPosition = newCanvasPosition
        , zoom = newZoom
    }


zoomIn : Model -> Model
zoomIn model =
    let
        newZoom =
            Zoom.nextLevelIn model.zoom

        newCanvasPosition =
            Zoom.zoom
                model.zoom
                newZoom
                Minimap.Constants.centerOfPortal
                model.canvasPosition
    in
    { model
        | canvasPosition = newCanvasPosition
        , zoom = newZoom
    }


setOpenState : OpenState -> Model -> Model
setOpenState openState model =
    { model | openState = openState }


setClickState : ClickState -> OpenModel -> OpenModel
setClickState clickState openModel =
    { openModel | clickState = clickState }


setCardPosition : Position -> OpenModel -> OpenModel
setCardPosition position openModel =
    { openModel | position = position }


setCanvasPosition : Position -> Model -> Model
setCanvasPosition position model =
    { model | canvasPosition = position }
