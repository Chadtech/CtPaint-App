module Tool.Update
    exposing
        ( update
        )

import Model exposing (Model)
import Position.Helpers as Position
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
    case model.tool of
        Hand subModel ->
            Hand.update msg subModel model

        Sample ->
            Sample.update
                (Msg.mapPosition (Position.onCanvas model) msg)
                model

        Fill ->
            Fill.update
                (Msg.mapPosition (Position.onCanvas model) msg)
                model

        Pencil subModel ->
            Pencil.update
                (Msg.mapPosition (Position.onCanvas model) msg)
                subModel
                model

        Line subModel ->
            Line.update
                (Msg.mapPosition (Position.onCanvas model) msg)
                subModel
                model

        ZoomIn ->
            ZoomIn.update msg model

        ZoomOut ->
            ZoomOut.update msg model

        Rectangle subModel ->
            Rectangle.update
                (Msg.mapPosition (Position.onCanvas model) msg)
                subModel
                model

        RectangleFilled subModel ->
            RectangleFilled.update
                (Msg.mapPosition (Position.onCanvas model) msg)
                subModel
                model

        Eraser subModel ->
            Eraser.update
                (Msg.mapPosition (Position.onCanvas model) msg)
                subModel
                model

        Select subModel ->
            Select.update
                (Msg.mapPosition (Position.onCanvas model) msg)
                subModel
                model
