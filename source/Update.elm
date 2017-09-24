module Update exposing (update)

--import Menu.Update as Menu

import Array
import Canvas exposing (DrawOp(Batch))
import ColorPicker
import Command
import History
import Json.Decode as Decode
import List.Unique
import Menu
import Minimap.Incorporate as Minimap
import Minimap.Update as Minimap
import Palette.Update as Palette
import Ports
import Tool.Update as Tool
import Types exposing (Model, Msg(..), keyPayloadDecoder)
import Util exposing ((&))


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ToolMsg subMsg ->
            Tool.update subMsg model
                |> Tuple.mapSecond (Cmd.map ToolMsg)

        MenuMsg subMsg ->
            case model.menu of
                Just menu ->
                    let
                        menuUpdate =
                            Menu.update subMsg menu
                    in
                    incorporateMenu menuUpdate model

                Nothing ->
                    model & Cmd.none

        PaletteMsg subMsg ->
            let
                ( newModel, cmd ) =
                    Palette.update subMsg model
            in
            ( newModel, Cmd.map PaletteMsg cmd )

        GetWindowSize size ->
            { model
                | windowSize = size
            }
                & Cmd.none

        SetTool tool ->
            { model
                | tool = tool
            }
                & Cmd.none

        KeyboardEvent json ->
            case Decode.decodeValue keyPayloadDecoder json of
                Ok payload ->
                    Command.update
                        (Command.fromKeyPayload payload model)
                        model

                Err err ->
                    model & Cmd.none

        Tick dt ->
            case model.pendingDraw of
                Batch [] ->
                    model & Cmd.none

                _ ->
                    { model
                        | canvas =
                            Canvas.draw
                                model.pendingDraw
                                model.canvas
                        , pendingDraw =
                            Canvas.batch []
                    }
                        & Cmd.none

        ColorPickerMsg subMsg ->
            let
                colorPickerUpdate =
                    ColorPicker.update subMsg model.colorPicker
            in
            incorporateColorPicker colorPickerUpdate model

        MinimapMsg subMsg ->
            case model.minimap of
                Just minimap ->
                    let
                        minimapUpdate =
                            Minimap.update subMsg minimap
                    in
                    Minimap.incorporate minimapUpdate model & Cmd.none

                Nothing ->
                    model & Cmd.none

        ScreenMouseMove { targetPos, clientPos } ->
            let
                x =
                    clientPos.x - targetPos.x - model.canvasPosition.x

                y =
                    clientPos.y - targetPos.y - model.canvasPosition.y
            in
            { model
                | mousePosition =
                    { x = x // model.zoom
                    , y = y // model.zoom
                    }
                        |> Just
            }
                & Cmd.none

        ScreenMouseExit ->
            { model
                | mousePosition =
                    Nothing
            }
                & Cmd.none

        HandleWindowFocus focused ->
            if focused then
                { model
                    | keysDown = List.Unique.empty
                }
                    & Cmd.none
            else
                model & Cmd.none

        DropDown maybeOption ->
            { model
                | taskbarDropped = maybeOption
            }
                & Cmd.none

        HoverOnto option ->
            case model.taskbarDropped of
                Nothing ->
                    model & Cmd.none

                Just currentOption ->
                    if currentOption == option then
                        model & Cmd.none
                    else
                        { model
                            | taskbarDropped = Just option
                        }
                            & Cmd.none

        Command cmd ->
            Command.update cmd model

        NoOp ->
            model & Cmd.none


incorporateMenu :
    ( Menu.Model, Menu.ExternalMsg )
    -> Model
    -> ( Model, Cmd Msg )
incorporateMenu ( menu, externalMsg ) model =
    case externalMsg of
        Menu.DoNothing ->
            { model
                | menu = Just menu
            }
                & Cmd.none

        Menu.Close ->
            { model
                | menu = Nothing
            }
                & Ports.returnFocus ()

        Menu.Cmd cmd ->
            { model | menu = Just menu }
                & Cmd.map MenuMsg cmd

        Menu.IncorporateImage image ->
            let
                size =
                    Canvas.getSize image

                canvas =
                    Canvas.getSize model.canvas

                imagePosition =
                    { x =
                        (canvas.width - size.width) // 2
                    , y =
                        (canvas.height - size.height) // 2
                    }
            in
            { model
                | selection =
                    Just ( imagePosition, image )
                , menu = Nothing
            }
                & Ports.returnFocus ()

        Menu.ScaleTo dw dh ->
            case model.selection of
                Nothing ->
                    let
                        newCanvas =
                            Canvas.scale dw dh model.canvas
                    in
                    { model
                        | canvas =
                            Canvas.scale dw dh model.canvas
                    }
                        & Ports.returnFocus ()

                Just ( pos, selection ) ->
                    let
                        newSelection =
                            Canvas.scale dw dh selection
                    in
                    { model
                        | selection =
                            Just ( pos, newSelection )
                    }
                        & Ports.returnFocus ()

        Menu.AddText str ->
            model & Cmd.none


incorporateColorPicker :
    ( ColorPicker.Model, ColorPicker.ExternalMsg )
    -> Model
    -> ( Model, Cmd Msg )
incorporateColorPicker ( colorPicker, maybeMsg ) model =
    case maybeMsg of
        ColorPicker.DoNothing ->
            { model
                | colorPicker = colorPicker
            }
                & Cmd.none

        ColorPicker.SetColor index color ->
            { model
                | colorPicker = colorPicker
                , palette =
                    Array.set
                        index
                        color
                        model.palette
            }
                & Cmd.none

        ColorPicker.UpdateHistory index color ->
            let
                newModel =
                    { model
                        | colorPicker = colorPicker
                    }
                        |> History.addColor index color
            in
            newModel & Cmd.none

        ColorPicker.StealFocus ->
            model & Ports.stealFocus ()

        ColorPicker.ReturnFocus ->
            model & Ports.returnFocus ()
