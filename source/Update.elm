module Update exposing (update)

import Array
import Canvas exposing (DrawOp(Batch))
import ColorPicker
import Command
import Draw
import History
import Menu
import Minimap
import Ports exposing (JsMsg(..))
import Tool.Update as Tool
import Tuple.Infix exposing ((&))
import Types
    exposing
        ( MinimapState(..)
        , Model
        , Msg(..)
        , keyPayloadDecoder
        , toUrl
        )
import Util exposing (origin)


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ToolMsg subMsg ->
            Tool.update subMsg model & Cmd.none

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

        GetWindowSize size ->
            { model | windowSize = size }
                & Cmd.none

        SetTool tool ->
            { model | tool = tool } & Cmd.none

        KeyboardEvent (Ok payload) ->
            Command.update
                (Command.fromKeyPayload payload model)
                model

        KeyboardEvent (Err err) ->
            model & Cmd.none

        Tick _ ->
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
                Minimap minimap ->
                    let
                        minimapUpdate =
                            Minimap.update subMsg minimap
                    in
                    incorporateMinimap minimapUpdate model

                _ ->
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

        PaletteSquareClick color ->
            let
                { swatches } =
                    model
            in
            { model
                | swatches =
                    { swatches
                        | primary = color
                    }
            }
                & Cmd.none

        OpenColorPicker color index ->
            { model
                | colorPicker =
                    ColorPicker.init True index color
            }
                & Cmd.none

        OpenNewWindow window ->
            model & Cmd.none

        AddPaletteSquare ->
            { model
                | palette =
                    Array.push
                        model.swatches.second
                        model.palette
            }
                & Cmd.none

        InitImgur ->
            { model
                | menu =
                    Menu.initImgur model.windowSize
                        |> Just
            }
                & Cmd.none


incorporateMinimap :
    ( Minimap.Model, Minimap.ExternalMsg )
    -> Model
    -> ( Model, Cmd Msg )
incorporateMinimap ( minimap, externalMsg ) model =
    case externalMsg of
        Minimap.DoNothing ->
            { model
                | minimap = Minimap minimap
            }
                & Cmd.none

        Minimap.Close ->
            { model
                | minimap =
                    Closed minimap.externalPosition
            }
                & Cmd.none


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
                & Ports.send ReturnFocus

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
                & Ports.send ReturnFocus

        Menu.ScaleTo dw dh ->
            case model.selection of
                Nothing ->
                    { model
                        | menu = Nothing
                        , canvas =
                            Canvas.scale dw dh model.canvas
                    }
                        |> History.addCanvas
                        & Ports.send ReturnFocus

                Just ( pos, selection ) ->
                    let
                        newSelection =
                            Canvas.scale dw dh selection
                    in
                    { model
                        | menu = Nothing
                        , selection =
                            Just ( pos, newSelection )
                    }
                        & Ports.send ReturnFocus

        Menu.AddText str ->
            { model
                | menu = Nothing
                , selection =
                    ( origin
                    , Draw.text
                        str
                        model.swatches.primary
                    )
                        |> Just
            }
                |> History.addCanvas
                & Ports.send ReturnFocus

        Menu.Replace target replacement ->
            case model.selection of
                Just ( position, selection ) ->
                    { model
                        | menu = Nothing
                        , selection =
                            ( position
                            , Draw.replace
                                target
                                replacement
                                selection
                            )
                                |> Just
                    }
                        & Cmd.none

                Nothing ->
                    { model
                        | menu = Nothing
                        , canvas =
                            Draw.replace
                                target
                                replacement
                                model.canvas
                    }
                        & Cmd.none


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
            model & Ports.send StealFocus

        ColorPicker.ReturnFocus ->
            model & Ports.send ReturnFocus
