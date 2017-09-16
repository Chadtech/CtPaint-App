module Update exposing (update)

import Canvas exposing (DrawOp(Batch))
import ColorPicker.Incorporate as ColorPicker
import ColorPicker.Update as ColorPicker
import Debug exposing (log)
import Keyboard.Update as Keyboard
import List.Unique
import Menu.Update as Menu
import Minimap.Incorporate as Minimap
import Minimap.Update as Minimap
import Model exposing (Model)
import Mouse exposing (Position)
import Msg exposing (Msg(..))
import Palette.Update as Palette
import Taskbar.Update as Taskbar
import Tool.Fill.Update as Fill
import Tool.Hand.Update as Hand
import Tool.Line.Update as Line
import Tool.Pencil.Update as Pencil
import Tool.Rectangle.Update as Rectangle
import Tool.RectangleFilled.Update as RectangleFilled
import Tool.Sample.Update as Sample
import Tool.Select.Update as Select
import Tool.Types exposing (Tool(..))
import Tool.ZoomIn.Update as ZoomIn
import Tool.ZoomOut.Update as ZoomOut


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case ( message, model.tool ) of
        ( TaskbarMsg subMsg, _ ) ->
            let
                ( newModel, cmd ) =
                    Taskbar.update subMsg model
            in
            ( newModel, Cmd.map TaskbarMsg cmd )

        ( MenuMsg subMsg, _ ) ->
            Menu.update subMsg model
                |> Tuple.mapSecond (Cmd.map MenuMsg)

        ( PaletteMsg subMsg, _ ) ->
            let
                ( newModel, cmd ) =
                    Palette.update subMsg model
            in
            ( newModel, Cmd.map PaletteMsg cmd )

        ( GetWindowSize size, _ ) ->
            { model
                | windowSize = size
            }
                ! []

        ( SetTool tool, _ ) ->
            { model
                | tool = tool
            }
                ! []

        ( KeyboardMsg subMsg, _ ) ->
            let
                ( newModel, cmd ) =
                    Keyboard.update subMsg model

                _ =
                    log "keys down" newModel.keysDown
            in
            newModel ! [ cmd ]

        ( HandMsg subMsg, Hand subModel ) ->
            let
                newModel =
                    Hand.update subMsg subModel model
            in
            newModel ! []

        ( SampleMsg subMsg, Sample ) ->
            Sample.update subMsg model ! []

        ( FillMsg subMsg, Fill ) ->
            Fill.update subMsg model ! []

        ( PencilMsg subMsg, Pencil subModel ) ->
            let
                newModel =
                    Pencil.update subMsg subModel model
            in
            newModel ! []

        ( LineMsg subMsg, Line subModel ) ->
            let
                newModel =
                    Line.update subMsg subModel model
            in
            newModel ! []

        ( ZoomInMsg subMsg, ZoomIn ) ->
            let
                newModel =
                    ZoomIn.update subMsg model
            in
            newModel ! []

        ( ZoomOutMsg subMsg, ZoomOut ) ->
            let
                newModel =
                    ZoomOut.update subMsg model
            in
            newModel ! []

        ( RectangleMsg subMsg, Rectangle subModel ) ->
            let
                newModel =
                    Rectangle.update subMsg subModel model
            in
            newModel ! []

        ( RectangleFilledMsg subMsg, RectangleFilled subModel ) ->
            let
                newModel =
                    RectangleFilled.update subMsg subModel model
            in
            newModel ! []

        ( Tick dt, _ ) ->
            case model.pendingDraw of
                Batch [] ->
                    model ! []

                _ ->
                    { model
                        | canvas =
                            Canvas.draw
                                model.pendingDraw
                                model.canvas
                        , pendingDraw =
                            Canvas.batch []
                    }
                        ! []

        ( ColorPickerMsg subMsg, _ ) ->
            let
                colorPickerUpdate =
                    ColorPicker.update subMsg model.colorPicker
            in
            ColorPicker.incorporate colorPickerUpdate model

        ( MinimapMsg subMsg, _ ) ->
            case model.minimap of
                Just minimap ->
                    let
                        minimapUpdate =
                            Minimap.update subMsg minimap
                    in
                    Minimap.incorporate minimapUpdate model ! []

                Nothing ->
                    model ! []

        ( ScreenMouseMove { targetPos, clientPos }, _ ) ->
            let
                x =
                    clientPos.x - targetPos.x - model.canvasPosition.x

                y =
                    clientPos.y - targetPos.y - model.canvasPosition.y

                position =
                    Position
                        (x // model.zoom)
                        (y // model.zoom)
            in
            { model
                | mousePosition =
                    Just position
            }
                ! []

        ( ScreenMouseExit, _ ) ->
            { model
                | mousePosition =
                    Nothing
            }
                ! []

        ( SelectMsg subMsg, Select subModel ) ->
            let
                newModel =
                    Select.update subMsg subModel model
            in
            newModel ! []

        ( HandleWindowFocus focused, _ ) ->
            if focused then
                { model
                    | keysDown = List.Unique.empty
                }
                    ! []
            else
                model ! []

        _ ->
            model ! []
