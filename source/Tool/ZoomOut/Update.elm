module Tool.ZoomOut.Update exposing (update)

import Tool.ZoomOut.Types exposing (Message(..))
import Tool.Zoom as Zoom
import Main.Model exposing (Model)


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
