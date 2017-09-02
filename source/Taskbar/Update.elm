module Taskbar.Update exposing (update)

import Main.Model exposing (Model)
import Taskbar.Types as Taskbar exposing (Message(..))
import Taskbar.Download.Types as Download
import Taskbar.Download.Update as Download
import Taskbar.Download.Handle as Download
import Types.Menu exposing (Menu(..))


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
                            , listenForKeyCmds = False
                        }
                            ! []

                Just projectName ->
                    { model
                        | listenForKeyCmds = False
                        , menu =
                            Download.initFromString
                                model.windowSize
                                projectName
                                |> Download
                    }
                        ! []

        _ ->
            model ! []
