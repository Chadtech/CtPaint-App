module Tool.Zoom.Out.Update
    exposing
        ( update
        )

import Model exposing (Model)
import Tool.Msg exposing (Msg(..))
import Tool.Zoom.Data.Direction as Direction
import Tool.Zoom.Helpers as Zoom


update : Msg -> Model -> Model
update msg model =
    case msg of
        WorkareaMouseUp positionInWindow ->
            model
                |> Zoom.out
                |> Zoom.moveTowardsClickPosition
                    positionInWindow
                    Direction.Out

        _ ->
            model
