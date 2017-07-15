module Tool.ZoomOut.Update exposing (update)

import Tool.ZoomOut.Types exposing (Message(..))
import Tool.Zoom as Zoom
import Main.Model exposing (Model)
import Mouse exposing (Position)
import Canvas
import Debug exposing (log)


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
                    setZoom newZoom position model


setZoom : Int -> Position -> Model -> Model
setZoom zoom position ({ canvas, canvasPosition, windowSize } as model) =
    let
        size =
            Canvas.getSize canvas

        x =
            List.sum
                [ canvasPosition.x
                , (size.width * zoom) // (Zoom.next zoom)
                ]

        y =
            List.sum
                [ canvasPosition.y
                , (size.height * zoom) // (Zoom.next zoom)
                ]
    in
        { model
            | zoom = zoom
            , canvasPosition =
                log "zooming out to" <| Position x y
        }
