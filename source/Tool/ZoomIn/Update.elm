module Tool.ZoomIn.Update exposing (update)

import Tool.Zoom as Zoom
import Tool.ZoomIn.Types exposing (Msg(..))
import Types exposing (Model)


update : Msg -> Model -> Model
update message model =
    case message of
        OnScreenMouseUp position ->
            let
                newZoom =
                    Zoom.next model.zoom
            in
            if model.zoom == newZoom then
                model
            else
                model
                    |> Zoom.set newZoom
                    |> Zoom.adjust position -1
