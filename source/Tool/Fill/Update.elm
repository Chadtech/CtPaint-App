module Tool.Fill.Update
    exposing
        ( update
        )

import Canvas exposing (DrawOp(PixelFill))
import Data.Position as Position
    exposing
        ( Position
        )
import Draw
import Draw.Model
import History.Helpers as History
import Model exposing (Model)
import Tool.Msg exposing (Msg(..))


update : Msg -> Model -> Model
update msg model =
    case msg of
        WorkareaMouseUp positionOnCanvas ->
            handleWorkareaMouseUp positionOnCanvas model

        _ ->
            model


handleWorkareaMouseUp : Position -> Model -> Model
handleWorkareaMouseUp positionOnCanvas model =
    if isntTheSameColor model positionOnCanvas then
        { model
            | draws =
                PixelFill
                    model.color.swatches.top
                    (Position.toPoint positionOnCanvas)
                    |> Draw.Model.addToPending
                    |> Draw.Model.applyTo model.draws
        }
            |> History.canvas
    else
        model


isntTheSameColor : Model -> Position -> Bool
isntTheSameColor { canvas, color } position =
    Draw.colorAt position canvas.main /= color.swatches.top
