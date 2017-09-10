module Palette.Update exposing (update)

import ColorPicker.Util as ColorPicker
import Keyboard.Extra exposing (Key(..))
import List.Unique
import Main.Message as MainMessage
import Main.Model exposing (Model)
import Palette.Types exposing (Message(..))
import Types.Mouse exposing (Direction(..))


update : Message -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        ResizeToolbar direction ->
            handleResize direction model

        WakeUpColorPicker color index ->
            let
                newModel =
                    ColorPicker.wakeUp
                        index
                        color
                        model
            in
            newModel ! []

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
                ! []


shiftIsDown : Model -> Bool
shiftIsDown { keysDown } =
    List.Unique.member
        (Keyboard.Extra.toCode Shift)
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
