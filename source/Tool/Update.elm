module Tool.Update exposing (update)

import Tool exposing (Msg(..), Tool(..))
import Tool.Fill.Update as Fill
import Tool.Hand.Update as Hand
import Tool.Line.Update as Line
import Tool.Pencil.Update as Pencil
import Tool.Rectangle.Update as Rectangle
import Tool.RectangleFilled.Update as RectangleFilled
import Tool.Sample.Update as Sample
import Tool.Select.Update as Select
import Tool.ZoomIn.Update as ZoomIn
import Tool.ZoomOut.Update as ZoomOut
import Types exposing (Model)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.tool ) of
        ( HandMsg subMsg, Hand subModel ) ->
            Hand.update subMsg subModel model ! []

        ( SampleMsg subMsg, Sample ) ->
            Sample.update subMsg model ! []

        ( FillMsg subMsg, Fill ) ->
            Fill.update subMsg model ! []

        ( PencilMsg subMsg, Pencil subModel ) ->
            Pencil.update subMsg subModel model ! []

        ( LineMsg subMsg, Line subModel ) ->
            Line.update subMsg subModel model ! []

        ( ZoomInMsg subMsg, ZoomIn ) ->
            ZoomIn.update subMsg model ! []

        ( ZoomOutMsg subMsg, ZoomOut ) ->
            ZoomOut.update subMsg model ! []

        ( RectangleMsg subMsg, Rectangle subModel ) ->
            Rectangle.update subMsg subModel model ! []

        ( RectangleFilledMsg subMsg, RectangleFilled subModel ) ->
            RectangleFilled.update subMsg subModel model ! []

        ( SelectMsg subMsg, Select subModel ) ->
            Select.update subMsg subModel model ! []

        _ ->
            model ! []
