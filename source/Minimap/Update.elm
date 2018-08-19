module Minimap.Update
    exposing
        ( update
        )

import Data.Position as Position
import Data.Size exposing (Size)
import Minimap.Model
    exposing
        ( ClickState(..)
        , Model
        , OpenModel
        , OpenState(..)
        )
import Minimap.Msg exposing (Msg(..))


type alias Payload =
    { windowSize : Size }


update : Payload -> Msg -> Model -> Model
update payload msg model =
    case model.openState of
        Closed position ->
            model

        Open openModel ->
            updateOpened payload msg openModel model


updateOpened : Payload -> Msg -> OpenModel -> Model -> Model
updateOpened { windowSize } msg openModel model =
    case msg of
        XButtonMouseUp ->
            Minimap.Model.close
                windowSize
                openModel
                model

        XButtonMouseDown ->
            { model
                | openState =
                    { openModel
                        | clickState =
                            XButtonIsDown
                    }
                        |> Open
            }

        ZoomInClicked ->
            Minimap.Model.zoomIn model

        ZoomOutClicked ->
            Minimap.Model.zoomOut model

        CenterClicked ->
            { model
                | canvasPosition =
                    { x = 0, y = 0 }
            }

        MinimapPortalMouseDown { targetPos, clientPos } ->
            clientPos
                |> Position.subtract model.canvasPosition
                |> ClickedInMinimapAt
                |> Minimap.Model.setClickState
                |> Minimap.Model.applyToOpenModel openModel
                |> Open
                |> Minimap.Model.setOpenState
                |> Minimap.Model.applyTo model

        HeaderMouseDown mouseEvent ->
            case openModel.clickState of
                XButtonIsDown ->
                    model

                _ ->
                    mouseEvent
                        |> Position.relativeToTarget
                        |> ClickedInHeaderAt
                        |> Minimap.Model.setClickState
                        |> Minimap.Model.applyToOpenModel openModel
                        |> Open
                        |> Minimap.Model.setOpenState
                        |> Minimap.Model.applyTo model

        MouseMoved position ->
            case openModel.clickState of
                NoClicks ->
                    model

                XButtonIsDown ->
                    model

                ClickedInHeaderAt originalClickPosition ->
                    position
                        |> Position.subtract originalClickPosition
                        |> Minimap.Model.setCardPosition
                        |> Minimap.Model.applyToOpenModel openModel
                        |> Open
                        |> Minimap.Model.setOpenState
                        |> Minimap.Model.applyTo model

                ClickedInMinimapAt originalClickPosition ->
                    position
                        |> Position.subtract originalClickPosition
                        |> Minimap.Model.setCanvasPosition
                        |> Minimap.Model.applyTo model

        MouseUp ->
            NoClicks
                |> Minimap.Model.setClickState
                |> Minimap.Model.applyToOpenModel openModel
                |> Open
                |> Minimap.Model.setOpenState
                |> Minimap.Model.applyTo model
