module Tool.ZoomOut.Update exposing (update)

import Main.Model exposing (Model)
import Tool.Zoom as Zoom
import Tool.ZoomOut.Types exposing (Message(..))


update : Message -> Model -> Model
update message model =
    case message of
        OnScreenMouseUp position ->
            let
                newZoom =
                    Zoom.prev model.zoom
            in
            if model.zoom == newZoom then
                model
            else
                model
                    |> Zoom.set newZoom
                    |> Zoom.adjust position 1
