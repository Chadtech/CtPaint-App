module Taskbar.Update exposing (update)

import Keyboard.Update as Keyboard
import Main.Model exposing (Model)
import Menu.Download.Incorporate as Download
import Menu.Download.Update as Download
import Menu.Import.Incorporate as Import
import Menu.Import.Update as Import
import Menu.Types exposing (Menu(..))
import Minimap.Types as Minimap
import Taskbar.Types as Taskbar exposing (Message(..))


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case ( message, model.menu ) of
        ( DropDown maybeOption, _ ) ->
            { model
                | taskbarDropped = maybeOption
            }
                ! []

        ( HoverOnto option, _ ) ->
            case model.taskbarDropped of
                Nothing ->
                    model ! []

                Just currentOption ->
                    if currentOption == option then
                        model ! []
                    else
                        { model
                            | taskbarDropped = Just option
                        }
                            ! []

        ( DownloadMessage subMessage, Download subModel ) ->
            let
                ( newModel, cmd ) =
                    subModel
                        |> Download.update subMessage
                        |> Download.incorporate model
            in
            ( newModel, Cmd.map DownloadMessage cmd )

        ( ImportMessage subMessage, Import subModel ) ->
            let
                ( newModel, cmd ) =
                    subModel
                        |> Import.update subMessage
                        |> Import.incorporate model
            in
            ( newModel, Cmd.map ImportMessage cmd )

        ( SwitchMinimap turnOn, _ ) ->
            if turnOn then
                { model
                    | minimap =
                        model.windowSize
                            |> Minimap.init
                            |> Just
                }
                    ! []
            else
                { model | minimap = Nothing } ! []

        ( Command cmd, _ ) ->
            Keyboard.keyUp model cmd ! []

        _ ->
            model ! []
