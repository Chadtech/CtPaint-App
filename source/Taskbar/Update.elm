module Taskbar.Update exposing (update)

import Keyboard.Update as Keyboard
import Main.Model exposing (Model)
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
