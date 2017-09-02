module Toolbar.Top.Update exposing (update)

import Main.Model exposing (Model)
import Toolbar.Top.Types as Taskbar exposing (Message(..))
import Toolbar.Top.Ports as Ports


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

        Download ->
            ( model, Ports.download "untitled" )

        NoOp ->
            model ! []
