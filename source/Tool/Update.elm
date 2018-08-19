module Tool.Update
    exposing
        ( update
        )

import Model exposing (Model, positionOnCanvas)
import Tool.Data exposing (Tool(..))
import Tool.Eraser.Update as Eraser
import Tool.Fill.Update as Fill
import Tool.Hand.Update as Hand
import Tool.Line.Update as Line
import Tool.Msg as Msg exposing (Msg(..))
import Tool.Pencil.Update as Pencil
import Tool.Rectangle.Update as Rectangle
import Tool.RectangleFilled.Update as RectangleFilled
import Tool.Sample.Update as Sample
import Tool.Select.Update as Select
import Tool.Zoom.In.Update as ZoomIn
import Tool.Zoom.Out.Update as ZoomOut


update : Msg -> Model -> Model
update msg model =
    let
        makeRelativeToCanvas : Msg -> Msg
        makeRelativeToCanvas =
            Msg.mapPosition (positionOnCanvas model)
    in
    case model.tool of
        Hand subModel ->
            Hand.update msg subModel model

        Sample ->
            Sample.update
                (makeRelativeToCanvas msg)
                model

        Fill ->
            Fill.update
                (makeRelativeToCanvas msg)
                model

        Pencil subModel ->
            Pencil.update
                (makeRelativeToCanvas msg)
                subModel
                model

        Line subModel ->
            Line.update
                (makeRelativeToCanvas msg)
                subModel
                model

        ZoomIn ->
            ZoomIn.update msg model

        ZoomOut ->
            ZoomOut.update msg model

        Rectangle subModel ->
            Rectangle.update
                (makeRelativeToCanvas msg)
                subModel
                model

        RectangleFilled subModel ->
            RectangleFilled.update
                (makeRelativeToCanvas msg)
                subModel
                model

        Eraser subModel ->
            Eraser.update
                (makeRelativeToCanvas msg)
                subModel
                model

        Select subModel ->
            Select.update
                (makeRelativeToCanvas msg)
                subModel
                model
