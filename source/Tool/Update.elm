module Tool.Update exposing (update)

import Tool exposing (Msg(..), Tool(..))
import Tool.Fill as Fill
import Tool.Hand.Update as Hand
import Tool.Line.Update as Line
import Tool.Pencil.Update as Pencil
import Tool.Rectangle.Update as Rectangle
import Tool.RectangleFilled.Update as RectangleFilled
import Tool.Sample as Sample
import Tool.Select.Update as Select
import Tool.Zoom exposing (zoomInScreenMouseUp, zoomOutScreenMouseUp)
import Types exposing (Model)
import Util exposing ((&))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.tool ) of
        ( HandMsg subMsg, Hand subModel ) ->
            let
                ( newModel, newHandModel ) =
                    Hand.update subMsg subModel model
            in
            { newModel
                | tool = Hand newHandModel
            }
                & Cmd.none

        ( SampleAt mouseEvent, Sample ) ->
            Sample.subMouseUp mouseEvent model & Cmd.none

        ( FillScreenMouseUp mouseEvent, Fill ) ->
            Fill.screenMouseUp mouseEvent model ! []

        ( PencilMsg subMsg, Pencil subModel ) ->
            Pencil.update subMsg subModel model ! []

        ( LineMsg subMsg, Line subModel ) ->
            Line.update subMsg subModel model ! []

        ( ZoomInScreenMouseUp position, ZoomIn ) ->
            zoomInScreenMouseUp position model & Cmd.none

        ( ZoomOutScreenMouseUp position, ZoomOut ) ->
            zoomOutScreenMouseUp position model & Cmd.none

        ( RectangleMsg subMsg, Rectangle subModel ) ->
            Rectangle.update subMsg subModel model ! []

        ( RectangleFilledMsg subMsg, RectangleFilled subModel ) ->
            RectangleFilled.update subMsg subModel model ! []

        ( SelectMsg subMsg, Select subModel ) ->
            let
                ( newModel, newSelectModel ) =
                    Select.update subMsg subModel model
            in
            { newModel
                | tool = Select newSelectModel
            }
                & Cmd.none

        _ ->
            model ! []
