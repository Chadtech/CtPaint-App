module Taskbar.Update exposing (update)

--import Keyboard.Update as Keyboard

import Minimap.Types as Minimap
import Taskbar.Types as Taskbar exposing (Msg(..))
import Types exposing (Model)
import Util exposing ((&))


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
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

        SwitchMinimap turnOn ->
            if turnOn then
                { model
                    | minimap =
                        model.windowSize
                            |> Minimap.init
                            |> Just
                }
                    & Cmd.none
            else
                { model | minimap = Nothing } & Cmd.none

        Command cmd ->
            model & Cmd.none

        --Keyboard.keyUp model cmd
        NoOp ->
            model & Cmd.none
