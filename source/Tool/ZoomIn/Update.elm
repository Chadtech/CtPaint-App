module Tool.ZoomIn.Update exposing (update)

import Tool.ZoomIn.Types exposing (Message(..))
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
                    Zoom.next model.zoom
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

        relZoom =
            (toFloat zoom) / (2 * toFloat model.zoom)

        --((canvasPosition.x - (windowSize.width // 2)) // (size.width * (Zoom.prev zoom)))
        x =
            let
                distFromCenter =
                    toFloat (canvasPosition.x - (windowSize.width // 2))

                dx =
                    round (distFromCenter * relZoom)
            in
                canvasPosition.x + dx

        --List.sum
        --    [ canvasPosition.x
        --    , -((size.width * (Zoom.prev zoom) // zoom))
        --    ]
        y =
            let
                distFromCenter =
                    toFloat (canvasPosition.y - (windowSize.height // 2))

                dy =
                    round (distFromCenter * relZoom)
            in
                canvasPosition.y + dy

        --List.sum
        --    [ canvasPosition.y
        --    , -((size.height * (Zoom.prev zoom) // zoom))
        --    ]
    in
        { model
            | zoom = zoom
            , canvasPosition =
                Position x y
        }
