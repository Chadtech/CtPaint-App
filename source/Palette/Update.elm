module Palette.Update exposing (update)

import Palette.Types exposing (Message(..))
import Types.Mouse exposing (Direction(..))
import Main.Model exposing (Model)
import Main.Message as MainMessage
import ColorPicker.Update as ColorPicker
import ColorPicker.Handle as ColorPicker
import ColorPicker.Types as ColorPicker
import List.Unique
import Keyboard.Extra exposing (Key(..))


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        ResizeToolbar direction ->
            handleResize direction model

        PaletteSquareClick color index ->
            if ctrlIsDown model then
                let
                    colorPickerUpdate =
                        ColorPicker.update
                            (ColorPicker.WakeUp color index)
                            model.colorPicker

                    newModel =
                        ColorPicker.handle
                            colorPickerUpdate
                            model
                in
                    ( newModel, Cmd.none )
            else
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
                        ! []


ctrlIsDown : Model -> Bool
ctrlIsDown { keysDown } =
    List.Unique.member
        (Keyboard.Extra.toCode Control)
        keysDown



-- RESIZE TOOL BAR --


handleResize : Direction -> Model -> ( Model, Cmd Message )
handleResize direction model =
    case direction of
        Down _ ->
            { model
                | subMouseMove =
                    Move
                        >> ResizeToolbar
                        >> MainMessage.PaletteMessage
                        |> Just
            }
                ! []

        Up _ ->
            { model
                | subMouseMove =
                    Nothing
            }
                ! []

        Move position ->
            let
                { width, height } =
                    model.windowSize
            in
                { model
                    | horizontalToolbarHeight =
                        height - position.y + 29
                }
                    ! []
