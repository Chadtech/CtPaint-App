module Toolbar.Top.Update exposing (update)

import Main.Model exposing (Model)
import Toolbar.Top.Types as Taskbar exposing (Message(..))


update : Message -> Model -> Model
update message model =
    case message of
        DropDown maybeOption ->
            { model
                | taskbarDropped = maybeOption
            }

        HoverOnto option ->
            case model.taskbarDropped of
                Nothing ->
                    model

                Just currentOption ->
                    if currentOption == option then
                        model
                    else
                        { model
                            | taskbarDropped = Just option
                        }

        NoOp ->
            model
