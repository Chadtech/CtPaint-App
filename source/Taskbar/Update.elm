module Taskbar.Update exposing (update)

import Main.Model exposing (Model)
import Taskbar.Types as Taskbar exposing (Message(..))
import Taskbar.Ports as Ports


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        DropDown maybeOption ->
            { model
                | taskbarDropped = maybeOption
            }
                ! []

        HoverOnto option ->
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

        InitDownload ->
            ( model, Ports.download "untitled" )

        NoOp ->
            model ! []
