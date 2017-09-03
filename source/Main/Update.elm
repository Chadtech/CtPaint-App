module Main.Update exposing (update)

import Main.Message exposing (Message(..))
import Main.Model exposing (Model)
import Palette.Update as Palette
import Tool.Hand.Update as Hand
import Tool.Pencil.Update as Pencil
import Tool.Line.Update as Line
import Tool.ZoomIn.Update as ZoomIn
import Tool.ZoomOut.Update as ZoomOut
import Tool.Rectangle.Update as Rectangle
import Tool.RectangleFilled.Update as RectangleFilled
import Tool.Select.Update as Select
import Tool.Sample.Update as Sample
import Tool.Fill.Update as Fill
import ColorPicker.Update as ColorPicker
import ColorPicker.Handle as ColorPicker
import Minimap.Update as Minimap
import Minimap.Handle as Minimap
import Taskbar.Update as Taskbar
import Tool.Types exposing (Tool(..))
import Canvas exposing (DrawOp(Batch))
import Keyboard.Update as Keyboard
import Mouse exposing (Position)
import List.Unique


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case ( message, model.tool ) of
        ( TaskbarMessage subMessage, _ ) ->
            let
                ( newModel, cmd ) =
                    Taskbar.update subMessage model
            in
                ( newModel, Cmd.map TaskbarMessage cmd )

        ( PaletteMessage subMessage, _ ) ->
            let
                ( newModel, cmd ) =
                    Palette.update subMessage model
            in
                ( newModel, Cmd.map PaletteMessage cmd )

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

        ( KeyboardMessage subMessage, _ ) ->
            let
                newModel =
                    Keyboard.update subMessage model
            in
                newModel ! []

        ( HandMessage subMessage, Hand subModel ) ->
            let
                newModel =
                    Hand.update subMessage subModel model
            in
                newModel ! []

        ( SampleMessage subMessage, Sample ) ->
            (Sample.update subMessage model) ! []

        ( FillMessage subMessage, Fill ) ->
            (Fill.update subMessage model) ! []

        ( PencilMessage subMessage, Pencil subModel ) ->
            let
                newModel =
                    Pencil.update subMessage subModel model
            in
                newModel ! []

        ( LineMessage subMessage, Line subModel ) ->
            let
                newModel =
                    Line.update subMessage subModel model
            in
                newModel ! []

        ( ZoomInMessage subMessage, ZoomIn ) ->
            let
                newModel =
                    ZoomIn.update subMessage model
            in
                newModel ! []

        ( ZoomOutMessage subMessage, ZoomOut ) ->
            let
                newModel =
                    ZoomOut.update subMessage model
            in
                newModel ! []

        ( RectangleMessage subMessage, Rectangle subModel ) ->
            let
                newModel =
                    Rectangle.update subMessage subModel model
            in
                newModel ! []

        ( RectangleFilledMessage subMessage, RectangleFilled subModel ) ->
            let
                newModel =
                    RectangleFilled.update subMessage subModel model
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

        ( ColorPickerMessage subMessage, _ ) ->
            let
                colorPickerUpdate =
                    ColorPicker.update subMessage model.colorPicker
            in
                (ColorPicker.handle colorPickerUpdate model) ! []

        ( MinimapMessage subMessage, _ ) ->
            case model.minimap of
                Just minimap ->
                    let
                        minimapUpdate =
                            Minimap.update subMessage minimap
                    in
                        (Minimap.handle minimapUpdate model) ! []

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

        ( SelectMessage subMessage, Select subModel ) ->
            let
                newModel =
                    Select.update subMessage subModel model
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
