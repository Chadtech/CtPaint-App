module Taskbar.Update exposing (update)

import Main.Model exposing (Model)
import Taskbar.Types as Taskbar exposing (Message(..))
import Taskbar.Download.Types as Download
import Taskbar.Download.Update as Download
import Taskbar.Download.Handle as Download
import Taskbar.Import.Types as Import
import Taskbar.Import.Update as Import
import Taskbar.Import.Handle as Import
import Types.Menu exposing (Menu(..))
import Minimap.Types as Minimap


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
                        |> Download.handle model
            in
                ( newModel, Cmd.map DownloadMessage cmd )

        ( ImportMessage subMessage, Import subModel ) ->
            let
                ( newModel, cmd ) =
                    subModel
                        |> Import.update subMessage
                        |> Import.handle model
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

        ( InitDownload, _ ) ->
            case model.projectName of
                Nothing ->
                    let
                        ( downloadModel, seed ) =
                            Download.initFromSeed
                                model.windowSize
                                model.seed
                    in
                        { model
                            | seed = seed
                            , menu = Download downloadModel
                        }
                            ! []

                Just projectName ->
                    { model
                        | menu =
                            Download.initFromString
                                model.windowSize
                                projectName
                                |> Download
                    }
                        ! []

        ( InitImport, _ ) ->
            { model
                | menu =
                    model.windowSize
                        |> Import.init
                        |> Import
            }
                ! []

        _ ->
            model ! []
