module Tool.Rectangle.Update exposing (update)

import Main.Model exposing (Model)
import Tool.Rectangle.Types exposing (Message(..))
import Tool.Types exposing (Tool(..))
import Tool.Util exposing (adjustPosition)
import Mouse exposing (Position)
import Draw.Rectangle as Rectangle
import Canvas exposing (Size)


update : Message -> Maybe Position -> Model -> Model
update message toolModel model =
    case ( message, toolModel ) of
        ( OnScreenMouseDown position, Nothing ) ->
            let
                adjustedPosition =
                    adjustPosition model 0 position
            in
                { model
                    | tool =
                        Rectangle (Just adjustedPosition)
                    , drawAtRender =
                        Rectangle.draw
                            model.swatches.primary
                            (Size 1 1)
                            adjustedPosition
                }

        ( SubMouseMove position, Just priorPosition ) ->
            let
                adjustedPosition =
                    adjustPosition model 29 position
            in
                model

        _ ->
            model
